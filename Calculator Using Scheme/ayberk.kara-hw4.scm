(define (twoOperatorCalculator ExprList)
(if (null? ExprList)
    0
(if (eqv? '+ (car ExprList))
    (twoOperatorCalculator (cdr ExprList))
(if (eqv? '- (car ExprList))
    (twoOperatorCalculator (cons (-(cadr ExprList)) (cddr ExprList)))
    (+ (car ExprList)
(twoOperatorCalculator (cdr ExprList)))))))
(define (fouroperatorcalculator ExprList)
(if (null? (cdr ExprList))
ExprList
(if (eqv? '/ (cadr ExprList))
    (fouroperatorcalculator (cons (/ (car ExprList) (caddr ExprList)) (cdddr ExprList)))
(if (eqv? '* (cadr ExprList))
    (fouroperatorcalculator (cons (* (car ExprList) (caddr ExprList)) (cdddr ExprList)))
    (cons (car ExprList) (fouroperatorcalculator (cdr ExprList)))))))
(define (RecList myRecList)
(if (pair? myRecList)
    (twoOperatorcalculator(fouroperatorcalculator (CalcN myRecList)))
    myRecList))

(define (CalcN ExprList)(map RecList ExprList))

(define (checkOperators ExprList)
(if (list? ExprList)
    (if (null? ExprList)
        #f
    (if (and (number? (car ExprList)) (null? (cdr ExprList)))
        #t
    (if (and (pair? (car ExprList)) (null? (cdr ExprList)))
        (checkOperators (car ExprList))
    (if (and (number? (car ExprList)) (or (eqv? '- (cadr ExprList)) (eqv? '+ (cadr ExprList)) (eqv? '/ (cadr ExprList)) (eqv? '* (cadr ExprList))))
        (checkOperators (cddr ExprList))
    (if (and (pair? (car ExprList)) (or (eqv? '- (cadr ExprList)) (eqv? '+ (cadr ExprList)) (eqv? '/ (cadr ExprList)) (eqv? '* (cadr ExprList))))
    (   and (checkOperators (car ExprList)) (checkOperators (cddr ExprList)))
    #f)))))
#f))


(define (calculator ExprList)
(if (checkOperators ExprList)
(twoOperatorCalculator (fouroperatorcalculator (CalcN ExprList)))
#f))