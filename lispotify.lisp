(in-package #:lispotify)

(export '(search-track))

(defun search-track (name)
  "search a track and return a list of tracks in jsown object format"
  (with-token
    (let* ((uri (concatenate 'string
                             "https://api.spotify.com/v1/search?q="
                             (quri:url-encode name)
                             "&type=track"))
           (raw-results (handler-case
                            (dex:get uri :headers `(("Authorization" . ,*access-token*)))
                          (dex:http-request-failed (e)
                            (format nil "~a" e)))))
      (val (val (parse raw-results) "tracks") "items"))))
