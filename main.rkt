
#lang racket

;(require "parser/parser.rkt")
(require json)


;(define ast (load-ast "files/sum.json"))

;;; (displayln ast)

(define (eval expr env)
    ;;; (displayln expr)
    ;;; (displayln (hash-ref (hash-ref expr 'expression) 'kind))
    ;(define aux (hash-ref expr 'expression))
    ;;; (displayln expr)
    (match (hash-ref expr 'kind)
        ["Int"
          (hash-ref expr 'value)]
        ["Str"
          (hash-ref expr 'value)]
        ["Binary" 
          (define leftt (eval (hash-ref expr 'lhs) env))
          (define op (hash-ref expr 'op))
          (define rightt (eval (hash-ref expr 'rhs) env))
          (eval-binary leftt op rightt)]
        ["Print"
          ;;; (displayln (hash-ref expr 'value))
          (define vp (eval (hash-ref expr 'value) env))
          (displayln vp)]
        ["expression"
          (eval (hash-ref expr 'kind) env)]
        
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
    [Rem (remainder lefths righths)]
    [Neq (not (= lefths righths))]
    [Lt  (< lefths righths)]
    [Gt  (> lefths righths)]
    [Lte (<= lefths righths)]
    [Gte (>= lefths righths)]
    [And (and lefths righths)]
    [Or  (or lefths righths)]
    ))

(define (read-json-file path)
  (call-with-input-file path
    (λ (in)
      (read-json in))
    #:mode 'text))

(eval (hash-ref (read-json-file "files/print.json") 'expression) 1)


#|
 #(struct:Program "files/sum.rinha"
  #(struct:Let "sum"
    #(struct:Function (n)
      #(struct:If
        #(struct:Binary
          #(struct:Var "n" (28 29 "files/sum.rinha"))
          Eq
          #(struct:Int 1 (33 34 "files/sum.rinha"))
          (28 34 "files/sum.rinha"))
        #(struct:Var "n" (42 43 "files/sum.rinha"))
        #(struct:Binary
          #(struct:Var "n" (59 60 "files/sum.rinha"))
          Add
          #(struct:Call
            #(struct:Var "sum" (63 66 "files/sum.rinha"))
            (#(struct:Binary
                #(struct:Var "n" (67 68 "files/sum.rinha"))
                Sub
                #(struct:Int 1 (71 72 "files/sum.rinha"))
                (67 72 "files/sum.rinha")))
            (63 73 "files/sum.rinha"))
          (59 73 "files/sum.rinha"))
        (24 77 "files/sum.rinha")))
    (10 79 "files/sum.rinha"))
  #(struct:Print
    #(struct:Call
      #(struct:Var "sum" (89 92 "files/sum.rinha"))
      (#(struct:Int 5 (93 94 "files/sum.rinha")))
      (89 95 "files/sum.rinha"))
    (82 96 "files/sum.rinha"))
  (0 96 "files/sum.rinha"))
|#