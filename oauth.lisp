(in-package #:lispotify)

(export '(spotify-oauth
          make-spotify-oauth
          base64-encoded
          with-token
          refresh-token
          get-code-web
          get-token
          token
          spotify-api-request))

(defclass spotify-oauth ()
  ((id
    :accessor id
    :initarg :id)
   (secret
    :accessor secret
    :initarg :secret)
   (base64-encoded
    :accessor base64-encoded
    :initarg :base64-encoded)
   (redirect-uri
    :accessor redirect-uri
    :initarg :redirect-uri)
   (scope
    :accessor scope
    :initarg :scope)
   (token-path
    :accessor token-path
    :initarg :token-path)
   (token
    :accessor token
    :initarg :token)))

(defvar *spotify-api* "https://api.spotify.com/v1/")

(defmethod write-token ((oauth spotify-oauth))
  (let ((json-token (to-json (token oauth))))
    (with-open-file (stream (token-path oauth)
                            :direction :output
                            :if-exists :supersede)
      (write-line json-token stream))))

(defun get-code-web (id scopes redirect-uri)
  (let* ((scope (cl-ppcre:regex-replace-all " " scopes "%20"))
         (link (format nil "https://accounts.spotify.com/authorize?~{~{~a~^=~}&~}"
                       `(("response_type" "code")
                         ("client_id" ,id)
                         ("scope" ,scope)
                         ("redirect_uri" ,redirect-uri)))))
    (uiop:run-program (concatenate 'string "xdg-open \"" link "\""))))

(defmethod get-token ((oauth spotify-oauth) code)
  (let* ((auth (concatenate 'string "Basic " (base64-encoded oauth)))
         (new-token (extend-js (parse (dex:post "https://accounts.spotify.com/api/token"
                                                :headers `(("Authorization" . ,auth))
                                                :content `(("grant_type" . "authorization_code")
                                                           ("code" . ,code)
                                                           ("redirect_uri" . ,(redirect-uri oauth)))))
                      ("exp-time" (+ 3600 (get-universal-time))))))
    (prog1 (setf (token oauth) new-token)
      (write-token oauth))))

(defun make-spotify-oauth (id secret redirect-uri scope code
                           &key (path (merge-pathnames ".cache/lispotify" (user-homedir-pathname))))
  (let* ((base64-encoded (cl-base64:string-to-base64-string (concatenate 'string id ":" secret)))
         (oauth-instance (make-instance
                          'spotify-oauth :id id :secret secret
                          :base64-encoded base64-encoded :redirect-uri redirect-uri
                          :scope scope :token-path path :token nil)))
    (setf (token oauth-instance)
          (if (probe-file (token-path oauth-instance))
              (jsown:parse (uiop:read-file-string (token-path oauth-instance)))
              (get-token oauth-instance code)))
    oauth-instance))

(defmethod refresh-token ((oauth spotify-oauth))
  (let* ((auth (concatenate 'string "Basic " (base64-encoded oauth)))
         (refresh-token (jsown:val (token oauth)  "refresh_token"))
         (raw-response (dex:post "https://accounts.spotify.com/api/token"
                                 :headers `(("Authorization" . ,auth))
                                 :content `(("grant_type" . "refresh_token")
                                            ("refresh_token" . ,refresh-token))))
         (new-token (extend-js (parse raw-response)
                      ("exp-time" (+ 3600 (get-universal-time)))
                      ("refresh_token" refresh-token))))
    (prog1 (setf (token oauth) new-token)
      (write-token oauth))))

(defmacro with-token (oauth &body body)
  "makes sure that you have a non-expired token"
  `(let ((tok (token ,oauth)))
     (if (or (> (get-universal-time) (jsown:val tok "exp-time")))
         (progn (refresh-token ,oauth)
                ,@body)
         ,@body)))

(defmethod authorization-header ((oauth spotify-oauth) &key headers)
  (let ((access-token (jsown:val (token oauth) "access_token")))
    (append `(("Authorization" . ,(format nil "Bearer ~a" access-token)))
            headers)))

(defmethod spotify-api-request ((oauth spotify-oauth) api &key (method :get) headers content)
  (with-token oauth
    (dex:request (concatenate 'string *spotify-api* api)
                 :headers (authorization-header oauth)
                 :content content
                 :method method)))
