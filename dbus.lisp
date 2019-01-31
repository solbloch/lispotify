(in-package :lispotify)
(export '(play-spotify-uri))

;; I know this is quite a silly way to do it, but loading :dbus is too slow and lame



(defun play-spotify-uri (spotify-uri)
  "calls spotify to play the uri with shell 'dbus-send' command"
  (sb-ext:run-program "/bin/sh"
                      (list "-c"
                        (concatenate 'string
                                     "dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.OpenUri "
                                    "string:" spotify-uri))))
