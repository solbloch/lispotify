# lispotify
### _sol b_

This is a project to use spotify.

Not much to it, really.

# how to use
go to spotify (specifically) [https://developer.spotify.com/dashboard](https://developer.spotify.com/dashboard) and click "create a client id".

make a file called `id.lisp` in the form of [example.lisp](example.lisp)

it should just run from then

# basic
`(load "path/to/lispotify.asd")`
`(ql:quickload :lispotify)`

then use whatever `(search-track "dfj")` and parse it (it gives back a list of jsown objects that are tracks, refer to the [spotify api details](https://developer.spotify.com/documentation/web-api/reference/tracks/get-several-tracks/)).
