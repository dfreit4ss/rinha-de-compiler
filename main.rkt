#lang racket
;(require "./interpreter/interpreter.rkt")
(require json 
        "interpreter/interpreter.rkt")


;(define ast (load-ast "files/sum.json"))

;;; (displayln ast)

(define (read-json-file path)
  (call-with-input-file path
    (λ (in)
      (read-json in))
    #:mode 'text))
(define env '(hash))
(eval (hash-ref (read-json-file "files/sum.json") 'expression) env)

