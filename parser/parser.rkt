#lang racket

(require json "../ast/ast.rkt")
(provide load-ast)



(define (parse-location loc)
  (list (hash-ref loc 'start)
        (hash-ref loc 'end)
        (hash-ref loc 'filename)))

;; JSON -> AST ===
(define (json->ast node)
  (define kind (hash-ref node 'kind))
  (match kind
    ["Let"
     (Let (hash-ref (hash-ref node 'name) 'text)
          (json->ast (hash-ref node 'value))
          (and (hash-has-key? node 'next)
               (json->ast (hash-ref node 'next)))
          (parse-location (hash-ref node 'location)))]
    
    ["Function"
     (Function (map (λ (p) (hash-ref p 'text))
                    (hash-ref node 'parameters))
               (json->ast (hash-ref node 'value))
               (parse-location (hash-ref node 'location)))]
    
    ["If"
     (If (json->ast (hash-ref node 'condition))
         (json->ast (hash-ref node 'then))
         (json->ast (hash-ref node 'otherwise))
         (parse-location (hash-ref node 'location)))]
    
    ["Binary"
     (Binary (json->ast (hash-ref node 'lhs))
             (hash-ref node 'op)
             (json->ast (hash-ref node 'rhs))
             (parse-location (hash-ref node 'location)))]
    
    ["Call"
     (Call (json->ast (hash-ref node 'callee))
           (map json->ast (hash-ref node 'arguments))
           (parse-location (hash-ref node 'location)))]
    
    ["Print"
     (Print (json->ast (hash-ref node 'value))
            (parse-location (hash-ref node 'location)))]
    
    ["Var"
     (Var (hash-ref node 'text)
          (parse-location (hash-ref node 'location)))]
    
    ["Int"
     (Int (hash-ref node 'value)
          (parse-location (hash-ref node 'location)))]
    ["Str"
    (Str (hash-ref node 'value)
        (parse-location (hash-ref node 'location)))]
    
    [else (error "Tipo de nó não suportado:" kind)]))

;; === Função para ler o JSON e transformar em AST ===
(define (read-json-file path)
  (call-with-input-file path
    (λ (in)
      (read-json in))
    #:mode 'text))

(define (load-ast path)
  (define data (read-json-file path))
  (Program (hash-ref data 'name)
           (json->ast (hash-ref data 'expression))
           (parse-location (hash-ref data 'location))))