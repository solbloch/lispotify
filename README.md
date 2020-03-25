# lispotify
### _sol bloch_

This is a project to use spotify.

Not much to it, really.

# how to use
go to spotify (specifically) [https://developer.spotify.com/dashboard](https://developer.spotify.com/dashboard) and click "create a client id".

# basic example

Check the [spotify scopes details](https://developer.spotify.com/documentation/web-api/reference/tracks/get-several-tracks/) to see what you want to do. 

Quick example to get the currently playing track:
```
(load "path/to/lispotify.asd")
(ql:quickload :lispotify)

(defvar id "some-code") ;;redacted, use your id
(defvar secret "some-secret") ;;redacted, use your secret
(defvar redirect "http://localhost:5000/") ;;not redacted, cause it doesn't matter
(defvar scopes "user-read-playback-state user-read-currently-playing")

(lispotify:get-code) ;;opens a browser with xdg-open, you login and it redirects you to your redirect-uri with the code you need as the code query param.

;; Example: redirected to http://localhost:5000/?code=blahblahblahblah 
;; copy blahblahblahblah

(defvar code "code") ;; copy paste it in

(defvar oauth-test (lispotify:make-spotify-oauth id secret redirect scopes code))

;; Get currently playing track example:

(lispotify:with-token oauth-test
  (multiple-value-bind (body status headers uri stream)
      (let ((auth (concatenate 'string
                               "Bearer "
                               (jsown:val (lispotify:token oauth-test) "access_token"))))
        (dex:get "https://api.spotify.com/v1/me/player/currently-playing"
                 :headers `(("Authorization" . ,auth))))
    body))
```
