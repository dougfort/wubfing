#lang racket

;; 

(require net/http-client)
(require json)

;; looking for '("HTTP/1.1" "200" "OK")
;; returning (status reason)
(define (parse-status-line status-line)
  (let ([parts ((compose1 string-split bytes->string/utf-8) status-line)])
    (values ((compose string->number second) parts) (string-join (drop parts 2)))))

;; webfinger entry point
(define (create-uri user-mention)
  (string-append "/.well-known/webfinger?resource=acct:" user-mention))

;; return http aliases
(define (finger user-mention)
  (let-values ([(status-line header-list data-port)
                (http-sendrecv
                 "mastodon.social"
                 (create-uri user-mention)
                 #:ssl? #t)])
    (let-values ([(status reason) (parse-status-line status-line)])
      (unless (= 200 status)
        (error (format "invalid HTTP status ~s; ~s" status reason))))
    (let ([finger-hash (read-json data-port)])
      (hash-ref finger-hash 'aliases))))
