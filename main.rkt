;;; #lang racket
;;; (require "parser/parser.rkt" )


;;; (json->ast (read-json-file "files/sum.json"))

#lang racket

(require "parser/parser.rkt")

(define ast (load-ast "files/sum.json"))
(displayln ast)
