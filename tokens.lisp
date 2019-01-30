(in-package #:lispotify)

(defvar *authorization*
  (let ((base-64-encoded (cl-base64:string-to-base64-string
                          (concatenate 'string *client-id* ":" *client-secret*))))
    (concatenate 'string "Basic " base-64-encoded)))

(defvar *access-token* "")

(defvar *token*
  (get-token))

(defun get-token ()
  (extend-js (parse (dex:post "https://accounts.spotify.com/api/token"
                              :content '(("grant_type" . "client_credentials"))
                              :headers `(("Authorization" . ,*authorization*))))
    ("exp-time" (+ 3600 (get-universal-time)))))

(defun renew-token ()
  (progn (setf *token*
               (get-token))
         (setf *access-token* (concatenate 'string "Bearer " (val *token* "access_token")))))


(defmacro with-token (&body body)
  `(if (> (get-universal-time) (val *token* "exp-time"))
       (progn (renew-token)
              ,@body)
       ,@body))
