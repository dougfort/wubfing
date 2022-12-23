#lang racket

;; 

(require net/http-client)

(define (finger name)
  (let-values ([(status-line header-list data-port)
                (http-sendrecv
                 "mastodon.social"
                 "/.well-known/webfinger?resource=acct:dougfort@mastodon.social"
                 #:ssl? #t)])
    (string-split (bytes->string/utf-8 status-line))))
