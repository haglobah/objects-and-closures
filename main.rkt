#lang racket

(require [only-in plait test print-only-errors])

(define hello (λ (name) (print (string-append "Hello " name))))

(define o
  (λ (msg)
    (case msg
      [(add1) (λ (n) (+ n 1))]
      [(sub1) (λ (n) (- n 1))])))

(test ((o 'add1) 0) 1)

(define (msg o m . a)
  (apply (o m) a))

(test (msg o 'add1 0) 1)

;; Constructors
(define (construct-symmetric x)
  (λ (msg)
    (case msg
      [(add) (λ (n) (+ x n))]
      [(sub) (λ (n) (- x n))])))

(define twelve (construct-symmetric 12))
(define ten (construct-symmetric 10))
(test (msg twelve 'add 4) 16)
(test (msg ten 'sub 4) 6)

;; But no state!
(test (msg twelve 'sub 4) 8)

;; With state
(define (make-o-with-state init)
  (let ([count init])
    (λ (msg)
      (case msg
        [(inc) (λ () (set! count (+ count 1)))]
        [(dec) (λ () (set! count (- count 1)))]
        [(get) (λ () count)]))))

(define with-state (make-o-with-state 0))
(msg with-state 'inc)
(msg with-state 'inc)
(msg with-state 'inc)
(msg with-state 'dec)
(test (msg with-state 'get) 2)

(define make-o-with-static
  (let ([instances 0])
    (λ (amount-or-msg)
      (case amount-or-msg
        [(instances) (λ () instances)]
        [else
         (begin
           (set! instances (+ 1 instances))
           (λ (msg)
             (case msg
               [(inc) (λ (n) (set! amount-or-msg (+ amount-or-msg n)))]
               [(dec) (λ (n) (set! amount-or-msg (- amount-or-msg n)))]
               [(get) (λ () amount-or-msg)])))]))))

(test (msg make-o-with-static 'instances) 0)
(test (let ([o (make-o-with-static 1000)]) (msg make-o-with-static 'instances)) 1)
(test (let ([o (make-o-with-static 0)]) (msg make-o-with-static 'instances)) 2)
