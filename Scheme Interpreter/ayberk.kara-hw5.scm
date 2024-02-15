(define get-operator (lambda (op-symbol env) 
  (cond 
    ((equal? op-symbol '+) +) 
    ((equal? op-symbol '-) -) 
    ((equal? op-symbol '*) *) 
    ((equal? op-symbol '/) /) 
    (else (get-value op-symbol env))
  )
))

(define single-operator?
  (lambda (expr)
    (and (list? expr)                ; Check if it's a list
         (= (length expr) 1)         ; Check if the length is 1
         (operator? (car expr)))))   ; Check if it's one of the specified operators

(define svoperator?
  (lambda (op-symbol)
    (member op-symbol '(+ - * /))))

(define if-statement? (lambda (e)
  (and (list? e) (equal? (car e) 'if) (= (length e) 4))
))

(define let-statement? (lambda (e)
  (and (list? e) (equal? (car e) 'let) (= (length e) 3))
))

(define define-stmt? (lambda (e)
  (and (list? e) (equal? (car e) 'define) (symbol? (cadr e)) (= (length e) 3))
))

(define normal-list? (lambda (e)
  (and (list? e) (symbol? (car e)) (or (null? (cdr e)) (normal-list? (cdr e))))
))

(define lambda-statement? (lambda (e)
  (and (list? e) (equal? (car e) 'lambda) (normal-list? (cadr e)) (not (define-stmt? (caddr e))))
))

(define is-normal? (lambda (o)
  (cond 
    ((eq? o '+) #t)
    ((eq? o '-) #t)
    ((eq? o '/) #t)
    ((eq? o '*) #t)
    (else #f)
  )
))

(define error1
  (lambda ()
    (display "cs305: ERROR")
    (newline)
    (newline)
    (repl '())
  )
)


(define get-value (lambda (var env)
  (cond 
    ((null? env) (error1)) 
    ((equal? (caar env) var) (cdar env)) 
    (else (get-value var (cdr env)))
  )
))

(define extend-env (lambda (var val old-env) 
  (cons (cons var val) old-env)
))

(define repl (lambda (env) 
  (let* ((dummy1 (display "cs305> ")) 
         (expr (read)) 
         (new-env (if (define-stmt? expr) 
                      (extend-env (cadr expr) (s7 (caddr expr) env) env) env)) 
         (val (if (define-stmt? expr) 
                  (cadr expr) 
                  (s7 expr env))) 
         (dummy2 (display "cs305: ")) 
         (dummy3 (display val)) 
         (dummy4 (newline)) 
         (dummy4 (newline))
  ) 
  (repl new-env))
))

(define s7 (lambda (e env) 
  (cond 
    ((number? e) e)
    ((symbol? e) (get-value e env)) 
    ((not (list? e)) (error1))
    ((if-statement? e) (if (eq? (s7 (cadr e) env) 0) 
                      (s7 (cadddr e) env) 
                      (s7 (caddr e) env))
    )
    ((let-statement? e)
      (let ((names (map car  (cadr e)))
            (inits (map cadr (cadr e))))
        (let ((vals (map (lambda (init) (s7 init env)) inits)))
          (let ((new-env (append (map cons names vals) env)))
            (s7 (caddr e) new-env))
          )
        )
      )
    ((lambda-statement? e) e)
    (else 
      (cond
        ((lambda-statement? (car e)) 
          (if (= (length (cadar e)) (length (cdr e)))
              (let* ((par (map s7 (cdr e) (make-list (length (cdr e)) env)))
                    (nenv (append (map cons (cadar e) par) env)))
                (s7 (caddar e) nenv))
              (error1))
        )
        ((is-normal? (car e)) 
          (let ((operands (map s7 (cdr e) (make-list (length (cdr e)) env)))
                (operator (get-operator (car e) env)))
            (cond 
              ((and (equal? operator '+) (= (length operands) 0)) 0)
              ((and (equal? operator '*) (= (length operands) 0)) 1)
              ((and (or (equal? operator '-) (equal? operator '/)) (= (length operands) (or 0 1)))
               (error1))
              (else (apply operator operands))
            )
          )
        )
        (else (let* ((result (s7 (list (get-value (car e) env) (cadr e)) env))) result))
      )
    )
  )
))

(define cs305 (lambda () (repl '())))
