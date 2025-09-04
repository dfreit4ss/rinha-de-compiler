#lang racket
(provide (all-defined-out))
    (require json)
;;; ;; === Definição dos nós da AST ===
;;; (struct Program (name expression location) #:transparent)
;;; (struct Let (name value next location) #:transparent)
;;; (struct Function (parameters value location) #:transparent)
;;; (struct If (condition then otherwise location) #:transparent)
;;; (struct Binary (lhs op rhs location) #:transparent)
;;; (struct Call (callee arguments location) #:transparent)
;;; (struct Print (value location) #:transparent)
;;; (struct Var (text location) #:transparent)
;;; (struct Int (value location) #:transparent)
;;; (struct Str (value location) #:transparent)


(require json)
(define (teste expr)
    (displayln (hash-ref expr 'expression))

    (eval )
    )


(define (read-json-file path)
  (call-with-input-file path
    (λ (in)
      (read-json in))
    #:mode 'text))

(teste (read-json-file "files/print.json"))