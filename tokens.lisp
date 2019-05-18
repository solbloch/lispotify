(in-package #:lispotify)

(export '(get-token
          renew-token
          *token*
          *access-token*))

(defun get-token ()
  "get a token and add 'exp-time' with the universal-time corresponding to the exp-time"
  (extend-js (parse
              (dex:post "https://accounts.spotify.com/api/token"
                        :content '(("grant_type" . "client_credentials"))
                        :headers `(("Authorization" . ,*authorization*))))
    ("exp-time" (+ 3600 (get-universal-time)))))

(defvar *authorization*
  (let ((base-64-encoded (cl-base64:string-to-base64-string
                          (concatenate 'string *client-id* ":" *client-secret*))))
    (concatenate 'string "Basic " base-64-encoded)))

(defvar *token* nil)

(defvar *access-token* nil)

(defun renew-token ()
  "grabs a new token and sets *token* and *access-token*"
  (setf *token* (get-token))
  (setf *access-token* (concatenate 'string "Bearer "
                                    (val *token* "access_token"))))

(defmacro with-token (&body body)
  "makes sure that you have a non-expired token"
  `(if (or (null *token*) (> (get-universal-time) (jsown:val *token* "exp-time")))
       (progn (renew-token)
              ,@body)
       ,@body))
