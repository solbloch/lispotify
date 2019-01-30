(in-package #:lispotify)

(defun cleanup-search (x)
  (regex-replace-all " " x "%20"))

(defun search-track (name)
  (with-token
    (let* ((uri (concatenate 'string
                             "https://api.spotify.com/v1/search?q="
                             (cleanup-search name)
                             "&type=track"))
           (raw-results (dex:get uri
                                 :headers `(("Authorization" . ,*access-token*)))))
      (val (val (parse raw-results) "tracks") "items"))))
