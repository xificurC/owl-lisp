
(define-library (owl digest)
   
   (export
      sha1            ;; str | vec | list | ll → str
      sha1-raw        ;; ditto → integer list
      sha1-bytes      ;; ditto → byte list
      hmac-sha1       ;; key, data → sha1 
      hmac-sha1-bytes ;; key, data → sha1 bytes
      )

   (import
      (owl defmac)
      (owl math)
      (owl list)
      (owl list-extra)
      (owl vector)
      (owl io)
      (owl string)
      (scheme base)
      (owl lazy))

   (begin

      (define sha1-blocksize 64)

      (define (n->bytes n)
         (let ((a (band n 255))
               (b (band (>> n 8) 255))
               (c (band (>> n 16) 255))
               (d (band (>> n 24) 255)))
            (values a b c d)))
                 
      (define (sha1-finish-pad bits)
         (cons #x80
            (let loop ((pos (band (+ bits 8) 511)))
               (if (= pos 448)
                  (lets ((bits (+ bits 0)) ;; +1 for #x80
                         (a b c d (n->bytes bits)) 
                         (e f g h (n->bytes (>> bits 32))))
                     (list h g f e d c b a))
                  (cons 0 (loop (band (+ pos 8)  511)))))))

      (define (word x) 
         (band x #xffffffff))

      (define (rol x n)
         (word
            (bor
               (<< x n)
               (>> x (- 32 n)))))

      (define (sha1-pad ll)
         (let loop ((ll ll) (bits 0))
            (cond
               ((pair? ll)
                  (cons (car ll)
                     (loop (cdr ll) (+ bits 8))))
               ((null? ll)
                  (sha1-finish-pad bits))
               (else
                  (λ () (loop (ll) bits))))))

      (define (grab-word ll)
         (lets
            ((a ll (uncons ll #false))
             (b ll (uncons ll #false))
             (c ll (uncons ll #false))
             (d ll (uncons ll #false)))
            (values (bor (bor d (<< c 8))
                         (bor (<< b 16) (<< a 24)))
                    ll)))
               
      (define (grab-initial-words ll)
         (lets ((a ll (uncons ll #false)))
            (if a ;;something in stream
               (let loop ((ll (cons a ll)) (ws null) (n 0))
                  (cond
                     ((= n 16)
                        (values ws ll))
                     (else
                        (lets ((x ll (grab-word ll)))
                           (loop ll (cons x ws) (+ n 1))))))
               (values #false null))))

      (define (xor-poss x n ps lst)
         (if (eq? n 1) 
            (if (null? ps)
               (bxor x (car lst))
               (xor-poss (bxor x (car lst)) (car ps) (cdr ps) (cdr lst)))
            (xor-poss x (- n 1) ps (cdr lst))))

      ;; i-3 i-8 i-14 i-16
      (define (extend-initial-words lst)
         (let loop ((lst lst) (n 16))
            (if (= n 80)
               lst
               (loop
                  (cons (rol (xor-poss 0 3 '(5 6 2) lst) 1) lst)
                  (+ n 1)))))

      (define (sha1-step a b c d e f k w)
         (values (word (+ (rol a 5) f e k w)) a (word (rol b 30)) c d))

      (define (bnot w)
         (bxor w #xffffffff))

      (define (sha1-chunk h0 h1 h2 h3 h4 ws)
         (let loop ((i 0) (a h0) (b h1) (c h2) (d h3) (e h4) (ws (reverse ws)))
            ;(print (list 'sha1-loop i a b c d e ws))
            (cond
               ((< i 20)
                  (lets ((f (bor (band b c) (band (bnot b) d)))
                         (k #x5a827999)
                         (a b c d e 
                           (sha1-step a b c d e f k (car ws))))
                     (loop (+ i 1) a b c d e (cdr ws))))
               ((< i 40)
                  (lets ((f (bxor b (bxor c d)))
                         (k #x6ed9eba1)
                         (a b c d e 
                           (sha1-step a b c d e f k (car ws))))
                     (loop (+ i 1) a b c d e (cdr ws))))
               ((< i 60)
                  (lets ((f (bor (bor (band b c) (band b d)) (band c d)))
                         (k #x8f1bbcdc)
                         (a b c d e 
                           (sha1-step a b c d e f k (car ws))))
                     (loop (+ i 1) a b c d e (cdr ws))))
               ((< i 80)
                  (lets ((f (bxor b (bxor c d)))
                         (k #xca62c1d6)
                         (a b c d e 
                           (sha1-step a b c d e f k (car ws))))
                     (loop (+ i 1) a b c d e (cdr ws))))
               (else
                  (values 
                     (word (+ h0 a))
                     (word (+ h1 b))
                     (word (+ h2 c))
                     (word (+ h3 d))
                     (word (+ h4 e)))))))

   (define (uint32->bytes n tail)
      (lets
         ((a (band n #xff)) (n (>> n 8))
          (b (band n #xff)) (n (>> n 8))
          (c (band n #xff)) (n (>> n 8))
          (d (band n #xff)))
         (ilist d c b a tail)))

   (define (ws->bytes ws)
      (foldr uint32->bytes null ws))

   ;; silly version for now
   (define (hash-bytes->string bs)
      (list->string
         (foldr
            (λ (b tl)
               (append (cdr (string->list (number->string (+ #x100 b) 16))) tl))
            null bs)))

   (define sha1-format-result 
      (o hash-bytes->string ws->bytes))

   (define (sha1-chunks ll)
      (let loop 
         ((ll (sha1-pad ll)) 
          (h0 #x67452301) 
          (h1 #xefcdab89) 
          (h2 #x98badcfe) 
          (h3 #x10325476) 
          (h4 #xc3d2e1f0))
         (lets ((ws ll (grab-initial-words ll)))
            (if ws
               (lets 
                  ((h0 h1 h2 h3 h4 
                     (sha1-chunk h0 h1 h2 h3 h4 
                        (extend-initial-words ws))))
                  (loop ll h0 h1 h2 h3 h4))
               (list h0 h1 h2 h3 h4)))))

   (define (sha1-raw thing)
      (sha1-chunks
         (cond
            ((string? thing) (str-iter-bytes thing))
            ((vector? thing) (vec-iter thing))
            (else thing))))

   (define sha1-bytes
      (o ws->bytes sha1-raw))

   (define sha1 
      (o sha1-format-result sha1-raw))

   (define (list-xor a b)
      (cond
         ((null? a) b)
         ((null? b) a)
         (else
            (lets ((a as a)
                   (b bs b))
               (cons (bxor a b)
                  (list-xor as bs))))))

   (define (make-hmac hasher blocksize)
      (lambda (key msg)
         (lets
            ((key (string->bytes key)) ;; we want to UTF-8 encode it
             (msg (string->bytes msg)) ;; ditto
             (key (if (> (length key) blocksize) (hasher key) key))
             (key
               (append key
                  (map (λ (x) 0)
                     (iota 0 1 (- blocksize (length key))))))
             (o-pad (map (λ (x) #x5c) (iota 0 1 blocksize)))
             (i-pad (map (λ (x) #x36) (iota 0 1 blocksize))))
            (hasher
               (append (list-xor o-pad key)
                  (hasher (append (list-xor i-pad key) msg)))))))
               
   (define hmac-sha1-bytes
      (make-hmac sha1-bytes sha1-blocksize))

   (define (hmac-sha1 k m)
      (hash-bytes->string
         (hmac-sha1-bytes k m)))
))


