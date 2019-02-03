# lispotify
### _sol bloch_

This is a project to use spotify.

Not much to it, really.

# how to use
go to spotify (specifically) [https://developer.spotify.com/dashboard](https://developer.spotify.com/dashboard) and click "create a client id".

make a file called `id.lisp` in the form of [example.lisp](example.lisp)

it should just run from then

# basic example
`(load "path/to/lispotify.asd")`
`(ql:quickload :lispotify)`

then use whatever `(search-track "dfj")` and parse it (it gives back a list of jsown objects that are tracks, refer to the [spotify api details](https://developer.spotify.com/documentation/web-api/reference/tracks/get-several-tracks/)).

```
(loop for i in (lispotify:search-track "what's going on donny hathaway")
      collecting
      `(,(concatenate 'string (jsown:val i "name") " - "
                      (format nil "~{~a~^ & ~}"
                              (loop for artist in (jsown:val i "artists")
                                    collecting (jsown:val artist "name"))))
        ,(jsown:val i "uri")))
        
        
(("What's Going On - Live Version - Donny Hathaway"
  "spotify:track:1QQgtnvXfArwOCq7zYSE5g")
 ("What's Going On - Donny Hathaway" "spotify:track:2kXshT838nizb8yB8a2TuD")
 ("What's Going On - Live @ the Troubadour, Hollywood CA - Donny Hathaway"
  "spotify:track:1zSgozTCF928FD2IKThfMf")
 ("What's Going On - Live at The Bitter End 1971 - Donny Hathaway"
  "spotify:track:6rH8EbNDKAcBVSumZt4BjS")
 ("What's Going on - Donny Hathaway" "spotify:track:2a5BsZ1G86eXinBDZKQwcb")
 ("What's Going on - Live - Donny Hathaway"
  "spotify:track:0Zl9JewcleSt4q00exb3IQ")
 ("What's Going On - Donny Hathaway" "spotify:track:2bWJgSuDoQ4XZQ8Np9ndZG")
 ("What's Going on - Live - Donny Hathaway"
  "spotify:track:2DHL1p9HwtrnJhi3DNvWyJ")
 ("What's Going On - Donny Hathaway" "spotify:track:3rCeB1IjyIE6mjaWG6Bz4g")
 ("What's Going On - Donny Hathaway" "spotify:track:48MhBWZoEpUIaZ77FVSUoG")
 ("What's Going On - Donny Hathaway" "spotify:track:7M1kJJOolgBANDDVFsRNlK")
 ("What's Going On - Donny Hathaway" "spotify:track:4lIVgpSdPyM0vX16EYNCYH")
 ("What's Going On - Donny Hathaway" "spotify:track:6MLUOGE1UQCAXRre5CR0Ny"))
```
