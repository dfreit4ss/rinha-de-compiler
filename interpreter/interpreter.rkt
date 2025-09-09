#lang racket
(require json)
(provide (all-defined-out))


;; env: lista associativa
(define empty-env '())

(define (env-lookup env name)
  (cond
    [(null? env) (error "Unbound variable" name)]
    [(equal? (caar env) name) (cdar env)]
    [else (env-lookup (cdr env) name)]))

(define (env-extend env name value)
  (cons (cons name value) env))

(define (eval expr env)
    (match (hash-ref expr 'kind)
        ["Int"
          (hash-ref expr 'value)]
        ["Str"
          (hash-ref expr 'value)]
        ["Let"
            (define name (hash-ref (hash-ref expr 'name) 'text))
            (define val (hash-ref expr 'value))
            (define new-env (env-extend env name val))
            (define next (hash-ref expr 'next)) 
            (displayln next)
            (if next
                (eval next new-env)
                val)
        
        ]
        ["Binary" 
          (define leftt (eval (hash-ref expr 'lhs) env))
          (define op (hash-ref expr 'op))
          (define rightt (eval (hash-ref expr 'rhs) env))
          (eval-binary leftt op rightt)]
        ["Print"
          (define vp (eval (hash-ref expr 'value) env))
          (displayln vp)]
        
        [else (error "Unsupported expression: " expr)]
     )
)
(define (eval-binary lefths op righths)
  (match op
    [Eq  (= lefths righths)]
    [Add (+ lefths righths)]
    [Sub (- lefths righths)]
    [Mul (* lefths righths)]
    [Div (/ lefths righths)]
    [Rem (remainder lefths righths)] ; %
    [Neq (not (= lefths righths))]
    [Lt  (< lefths righths)]
    [Gt  (> lefths righths)]
    [Lte (<= lefths righths)]
    [Gte (>= lefths righths)]
    [And (and lefths righths)]
    [Or  (or lefths righths)]
    ))
