(in-package :lispotify)

(defvar *client-id* "b0e5640832dd40e69d94009517638de4")
(defvar *client-secret* "d80c8c477d0540e1b5f3c89de32692ad")

(defvar *authorization*
  (let ((base-64-encoded (cl-base64:string-to-base64-string
                          (concatenate 'string *client-id* ":" *client-secret*))))
    (concatenate 'string "Basic " base-64-encoded)))

(defvar *token*
  (parse (dex:post "https://accounts.spotify.com/api/token"
                   :content '(("grant_type" . "client_credentials"))
                   :headers `(("Authorization" . ,*authorization*)))))

(defvar *access-token* (concatenate 'string "Bearer " (val *token* "access_token")))
