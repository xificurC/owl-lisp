(define-library (owl list)

   (export 
      null pair? null?
      caar cadr cdar cddr
      list?      
      zip for fold foldr map for-each
      has? getq last drop-while
      mem
      fold-map foldr-map
      append reverse keep remove 
      all some
      smap unfold
      take-while                ;; pred, lst -> as, bs
      fold2
      first
      halve
      edit                      ;; op lst → lst'
      interleave
      ╯°□°╯
      
      diff union intersect)

   (import
      (owl defmac)
      (owl primop)
      (owl boolean))

   (begin

      ;; constants are always inlined, so you pay just one byte of source for readability

      (define null '())

      ;; any -> bool
      (define (pair? x) (eq? type-pair (type x)))

      ;; any -> bool
      (define (null? x) (eq? x null))

      (define-syntax withcc
         (syntax-rules ()
            ((withcc name proc)
               (call/cc (λ (name) proc)))))

      ;; '((a . b) . c) -> a
      (define (caar x) (car (car x)))
      ;; '(a . (b . c)) -> b
      (define (cadr x) (car (cdr x)))
      ;; '((a . b) . c) -> b
      (define (cdar x) (cdr (car x)))
      ;; '(a . (b . c)) -> c
      (define (cddr x) (cdr (cdr x)))

      ;; any -> bool, check if a thing is a linked list, O(n)
      (define (list? l)
         (cond
            ((null? l) #true)
            ((pair? l) (list? (cdr l)))
            (else #false)))

      ;; fn as bs -> ((fn a b) ...), zip values of lists together with a function
      ;;    (zip cons '(1 2 3) '(a b c d)) = '((1 . a) (2 . b) (3 . c))
      (define (zip op a b)
         (cond
            ((null? a) null)
            ((null? b) null)
            (else
               (let ((hd (op (car a) (car b))))
                  (cons hd (zip op (cdr a) (cdr b)))))))

         
      (define (for st l op)
         (if (null? l)
            st
            (for (op st (car l)) (cdr l) op)))

      ;; op state lst -> state', walk over a list from left and compute a value
      ;;    (fold - 0 '(1 2 3)) = -6
      ;;    (fold (lambda (a b) (cons b a)) null '(a b c)) = '(c b a)
      (define (fold op state lst) 
         (if (null? lst) 
            state 
            (fold op 
               (op state (car lst))
               (cdr lst))))

      (define (unfold op st end?)
         (if (end? st)
            null
            (lets ((this st (op st)))
               (cons this (unfold op st end?)))))

      ;; op s1 s2 lst -> s1' s2', fold with 2 states
      (define (fold2 op s1 s2 lst)
         (if (null? lst)
            (values s1 s2)
            (lets ((s1 s2 (op s1 s2 (car lst))))
               (fold2 op s1 s2 (cdr lst)))))

      ;; op st lst -> st', compute a value from the right
      ;;    (foldr - 0 '(1 2 3)) = 2
      ;;    (foldr cons null '(a b c)) = '(a b c)
      (define (foldr op st lst)
         (if (null? lst)
            st
            (op (car lst)
               (foldr op st (cdr lst)))))

      ;; fn lst -> lst', run a function to all elements of a list
      ;;    (map even? '(1 2 3)) = '(#false #true #false)
      (define (map fn lst)
         (if (null? lst)
            null
            (lets 
               ((hd tl lst)
                (hd (fn hd))) ;; compute head first
               (cons hd (map fn tl)))))

      ;; fn lst -> _, run a function to all elements of a list for side effects
      (define (for-each op lst)
         (if (null? lst)
            null
            (begin
               (op (car lst))
               (for-each op (cdr lst)))))

      ;; lst key -> bool
      (define (has? lst x)
         (cond
            ((null? lst) #false)
            ((eq? (car lst) x) lst)
            (else (has? (cdr lst) x))))

      ;; lst k -> #false | value, get a value from an association list
      (define (getq lst k)
         (cond
            ((null? lst) #false)
            ((eq? k (car (car lst))) (car lst))
            (else (getq (cdr lst) k))))

      ;; last list default -> last-elem | default, get the last value of a list
      (define (last l def)
         (fold (λ (a b) b) def l)) 

      ;; mem compare lst elem -> bool, check if lst contains elem comparing with compare
      (define (mem cmp lst elem)
         (cond
            ((null? lst) #false)
            ((cmp (car lst) elem) lst)
            (else (mem cmp (cdr lst) elem))))

      (define (app a b app)
         (if (null? a)
            b
            (cons (car a) (app (cdr a) b app))))
      
      (define (appl l appl)
         (if (null? (cdr l))
            (car l)
            (app (car l) (appl (cdr l) appl) app)))

      ;; append list ... -> list', join lists
      ;;    (append '(1) '() '(2 3)) = '(1 2 3)
      (define append
         (case-lambda 
            ((a b) (app a b app))
            ((a b . cs) (app a (app b (appl cs appl) app) app))
            ((a) a)
            (() null)))

      ; todo: update to work like ledit
      (define (edit op l)
         (if (null? l)
            l
            (let ((x (op (car l))))
               (if x
                  (append x (edit op (cdr l)))
                  (cons (car l) (edit op (cdr l)))))))

      ;(define (reverse l) (fold (λ (r a) (cons a r)) null l))

      (define (rev-loop a b)
         (if (null? a)
            b
            (rev-loop (cdr a) (cons (car a) b))))

      ;; lst -> lst', reverse a list
      (define (reverse l) (rev-loop l null))   

      ;; misc

      (define (drop-while pred lst)
         (cond
            ((null? lst) lst)
            ((pred (car lst))
               (drop-while pred (cdr lst)))
            (else lst)))

      (define (take-while pred lst)
         (let loop ((lst lst) (taken null))
            (cond
               ((null? lst) (values (reverse taken) null))
               ((pred (car lst)) (loop (cdr lst) (cons (car lst) taken)))
               (else (values (reverse taken) lst)))))

      (define (keep pred lst)
         (foldr (λ (x tl) (if (pred x) (cons x tl) tl)) null lst))

      (define (remove pred lst)
         (keep (o not pred) lst))

      (define (all pred lst)
         (withcc ret
            (fold (λ (ok x) (if (pred x) ok (ret #false))) #true lst)))

      (define (some pred lst) 
         (withcc ret
            (fold (λ (_ x) (let ((v (pred x))) (if v (ret v) #false))) #false lst)))

      ; map carrying one state variable down like fold
      (define (smap op st lst)
         (if (null? lst)
            null
            (lets ((st val (op st (car lst))))
               (cons val
                  (smap op st (cdr lst))))))


      ; could also fold
      (define (first pred l def)
         (cond
            ((null? l) def)
            ((pred (car l)) (car l))
            (else (first pred (cdr l) def))))

      (define (fold-map o s l)
         (let loop ((s s) (l l) (r null))
            (if (null? l)
               (values s (reverse r))
               (lets ((s a (o s (car l))))
                  (loop s (cdr l) (cons a r))))))

      (define (foldr-map o s l)
         (if (null? l)
            (values s null)
            (lets
               ((a (car l))
                (s l (foldr-map o s (cdr l))))
               (o a s))))


      (define (diff a b)
         (cond
            ((null? a) a)
            ((has? b (car a))
               (diff (cdr a) b))
            (else
               (cons (car a)
                  (diff (cdr a) b)))))

      (define (union a b)
         (cond
            ((null? a) b)
            ((has? b (car a))
               (union (cdr a) b))
            (else
               (cons (car a)
                  (union  (cdr a) b)))))

      (define (intersect a b)
         (cond
            ((null? a) null)
            ((has? b (car a))
               (cons (car a)
                  (intersect (cdr a) b)))
            (else
               (intersect (cdr a) b))))

      (define (interleave mid lst)
         (if (null? lst)
            null
            (let loop ((a (car lst)) (as (cdr lst)))
               (if (null? as)
                  (list a)
                  (ilist a mid (loop (car as) (cdr as)))))))

      ;; lst → a b, a ++ b == lst, length a = length b | length b + 1
      (define (halve lst)
         (let walk ((t lst) (h lst) (out null))
            (if (null? h)
               (values (reverse out) t)
               (let ((h (cdr h)))
                  (if (null? h)
                     (values (reverse (cons (car t) out)) (cdr t))
                     (walk (cdr t) (cdr h) (cons (car t) out)))))))

      (define ╯°□°╯ reverse)     
))
