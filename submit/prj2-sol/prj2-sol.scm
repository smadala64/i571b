#!/usr/bin/env racket
;comment out following line to run in repl
#lang racket
(require rackunit)
;to trace function fn, add (trace fn) after fn's definition
(require racket/trace)  

;;; Some of the exercises below refer to employees.
;;; An employee is represented by a 4-tuple (name age department salary)
;;test data for employees

(define EMPLOYEES
  '((tom 33 cs 85000.00)
    (joan 23 ece 110000.00)
    (bill 29 cs 69500.00)
    (john 28 me 58200.00)
    (sue 19 cs 22000.00)
    ))



;; #1: 15-points

;;return list of employees having department dept
;;must be implemented recursively
;; Hint: use equal? to check for department equality

(define (add-recursive dept employees)
  (cons (car employees) (dept-employees dept (cdr employees)))
  )
(define (dept-employees dept employees)
  (cond
   [(= 0 (length employees) ) '()]
   [(equal? dept (caddar employees)) (add-recursive dept employees)]
   [else (dept-employees dept (cdr employees))]
    )
  )
;(dept-employees 'ece EMPLOYEES)



(check-equal? (dept-employees 'ece EMPLOYEES) '((joan 23 ece 110000.00)))
(check-equal? (dept-employees 'cs EMPLOYEES)
 	      '((tom 33 cs 85000.00)
 		(bill 29 cs 69500.00)
 		(sue 19 cs 22000.00)
 		))
(check-equal? (dept-employees 'ce EMPLOYEES) '())



;; #2: 5-points
;;return list of names of employees belonging to department dept
;;must be implemented recursively
;;Hint: almost the same as the previous exercise
(define (add-name-recursive dept employees)
  (cons (caar employees) (dept-employees-names dept (cdr employees)))
  )
(define (dept-employees-names dept employees)
  (cond
   [(= 0 (length employees) ) '()]
   [(equal? dept (caddar employees)) (add-name-recursive dept employees)]
   [else (dept-employees-names dept (cdr employees))]
    )
  )
;(dept-employees-names 'ece EMPLOYEES)
 (check-equal? (dept-employees-names 'ece EMPLOYEES) '(joan))
 (check-equal? (dept-employees-names 'cs EMPLOYEES) '(tom bill sue))
 (check-equal? (dept-employees-names 'ce EMPLOYEES) '())


;; #3: 15-points
;;Given list indexes containing 0-based indexes and a list possibly
;;containing lists nested to an abitrary depth, return the element
;;in list indexed successively by indexes. Return 'nil if there is
;;no such element.
;;Hint: use list-ref
(define (list-access indexes list)
(if (null? indexes) list (if(> (length list) (car indexes)) (if (null? (cdr indexes))
(list-ref list (car indexes)) (list-access (cdr indexes) (list-ref list (car indexes)))) 'nil)))
;(list-access '() '((1 2 3) (4 (5 6 (8)))) )

 (check-equal? (list-access '(1) '(a b c)) 'b)
 (check-equal? (list-access '(2) '(a b (c))) '(c))
 (check-equal? (list-access '(2 0) '(a b (c))) 'c)
 (check-equal? (list-access '(3) '(a b (c))) 'nil)
 (check-equal? (list-access '(2 1) '(a b (c))) 'nil)  
 (check-equal? (list-access '() '((1 2 3) (4 (5 6 (8)))) )
 	      '((1 2 3) (4 (5 6 (8)))))
 (check-equal? (list-access '(1) '((1 2 3) (4 (5 6 (8)))) )
 	      '(4 (5 6 (8))))
 (check-equal? (list-access '( 1 1 2) '((1 2 3) (4 (5 6 (8)))) )
 	      '(8))
 (check-equal? (list-access '( 1 1 2 0) '((1 2 3) (4 (5 6 (8)))) )
 	      '8)
 (check-equal? (list-access '(0 1) '((1))) 'nil)



;; #4: 15-points
;;return sum of salaries for all employees
;;must be tail-recursive
;;Hint: use a nested auxiliary function with an accumulating parameter
(define (sum employees)
    (+ (car (cdddar employees)) (employees-salary-sum (cdr employees)))
  )
(define (employees-salary-sum employees)
  (cond
    [(= 0 (length employees)) 0]
    [else (sum employees)]
    )
  )
;(employees-salary-sum EMPLOYEES)
 (check-equal? (employees-salary-sum EMPLOYEES) 344700.00)
 (check-equal? (employees-salary-sum '()) 0)



;; #5: 15-points
;;return list of pairs giving name and salary of employees belonging to
;;department dept
;;cannot use recursion
;;Hint: use filter and map from the standard Racket library
;;(google "racket filter", "racket map")

(define (fil-dept dept employees)
  (filter (lambda (x) (eqv? dept (caddr x))) employees)
  )
(define (dept-employees-names-salaries dept employees)
  ;(map (lambda (fil) (list (car fil) (cadddr fil)) ) (filtering dept employees))
  (map (lambda (fil) (append (list(car fil)) (cdddr fil)) ) (fil-dept dept employees))
  )
;(dept-employees-names-salaries 'ece EMPLOYEES)
 (check-equal? (dept-employees-names-salaries 'ece EMPLOYEES) '((joan 110000.00)))
 (check-equal? (dept-employees-names-salaries 'cs EMPLOYEES)
 	      '((tom 85000.00)
 		(bill 69500.00)
 		(sue 22000.00)
 		))
 (check-equal? (dept-employees-names-salaries 'ce EMPLOYEES) '())



;; #6: 15-points
;;return average salary of all employees; 0 if employees empty
;;cannot use recursion
;;Hint: use foldl from the standard Racket library
;;(google "racket foldl").
(define (avg number employees)
  (cond
    ((= 0 (length employees)) 0)
    (else (/ number (length employees)))
  ))

(define (employees-average-salary employees)
  (avg (foldl + 0 (map (lambda (x) (cadddr x)) employees)) employees)
  )
;(employees-average-salary EMPLOYEES)
 (check-equal? (employees-average-salary EMPLOYEES) (/ 344700.00 5))
 (check-equal? (employees-average-salary '()) 0)



;; #7: 20-points
;; given an integer or list of nested lists containing integers,
;; return a string containing its JSON representation without any
;; whitespace
;; Hints: use (number->string n) to convert integer n to a string.
;;        use (string-append str1 str2 ...) to append str1 str2 ...
;;        use (string-join str-list sep) to join strings in str-list using sep
;; also see toJson() methods in java-no-deps Parser.java in prj1-sol

(define (int-list-json num-list)
  (if (number? num-list) (number->string num-list) (string-append "[" (string-join ( map (lambda(x)(if(number? x) (number->string x)(int-list-json x ))) num-list) ",") "]")))
;  (int-list-json '())
    
 (check-equal? (int-list-json '(1 2 3)) "[1,2,3]")
 (check-equal? (int-list-json '(1 (2 (4 5) 6))) "[1,[2,[4,5],6]]")
 (check-equal? (int-list-json '()) "[]")
 (check-equal? (int-list-json 42) "42")

	 
