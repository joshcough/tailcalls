#lang slideshow

(require slideshow/code)
(require scheme/pretty)

(define (large-text txt)
  (text txt (current-main-font) 62))

(define (left-align txt) (para #:align 'left txt))
(define (center-align txt) (para #:align 'center txt))

(define (display-stack title frames hidden-count)
    (apply slide (append 
      (list (para #:align 'center (large-text title)) (blank 50))
      (map (lambda (frame) (left-align "")) (take frames hidden-count))
      (map (lambda (frame) (left-align frame)) (drop frames hidden-count))
    )))

(define (forward-call-stack title frames)
  (for ([hidden (in-range (- (length frames) 1) -1 -1)]) (display-stack title frames hidden))
)

(define (rewind-call-stack title frames)
  (for ([hidden (in-range 0 (length frames))]) (display-stack title frames hidden))
)

(define (tail-call-stack frames)
  (for ([f frames]) (display-stack (list f) 0))
)

;;;;;;;;;; TITLE SLIDE ;;;;;;;;;;
(slide
 (para #:align 'center (large-text "Tail Calls"))
 (blank 50)
 (vc-append 0 (t "Josh Cough"))
)

;;;;;;;;;; TAIL CALL EXAMPLE ;;;;;;;;;;
(slide 
 (para #:align 'center (large-text "Tail Call"))
 (blank 50)
 (t "When the last thing a function does is call another function."))

(slide 
 (para #:align 'center (large-text "Tail Call Example"))
 (blank 50)
 (vl-append
    (tt "def a() {")
    (tt "  b() // regular call")
    (tt "  c() // tail call")
    (tt "}")
 ))

(slide 
 (para #:align 'center (large-text "Not a Tail Call"))
 (blank 50)
 (vl-append
    (tt "def a(): Int = {")
    (tt "  b() // regular call")
    (tt "  c() // regular call")
    (tt "  7   // not a call.")
    (tt "}")
 ))

(define evenodd
  (vl-append
    (tt "def even(n:Int): Int =")
    (tt "  if(n==0) true else odd(n-1)")
    (tt "")
    (tt "def odd(n:Int): Int =")
    (tt "  if(n==0) false else even(n-1)")))

;;;;;;;;;; BASIC EXISTS IMPL ;;;;;;;;;;
(define basic-exists
  (vl-append
   (tt "def exists[T](p: T => Boolean,")
   (tt "              list:List[T]): Boolean = ")
   (tt "  list match {")
   (tt "    case Nil => false")
   (tt "    case x::xs => if(p(x)) true ")
   (tt "                  else exists(p, xs)")
   (tt "  }")))

(define easier-to-understand-exists
  (vl-append
   (tt "0  def exists[T](p: T => Boolean,")
   (tt "1                list:List[T]): Boolean = ")
   (tt "2    val result = list match {")
   (tt "3      case Nil => false")
   (tt "4      case x::xs => if(p(x)) true ")
   (tt "5                   else exists(p, xs)")
   (tt "6    return result")
   (tt "7  }")))


;;;;;;;;;; TAIL RECURSION ;;;;;;;;;;
(slide 
 (para #:align 'center (large-text "Tail Recursion"))
 (blank 50)
 (t "When the last thing a function does is call itself."))

(slide 
 (para #:align 'center (large-text "Tail Recursion Example"))
 (blank 50)
 'alts
 (list
  (list basic-exists)
  (list (vl-append
   (tt "def exists[T](p: T => Boolean,")
   (tt "              list:List[T]): Boolean = ")
   (tt "  list match {")
   (tt "    case Nil => false")
   (tt "    case x::xs => if(p(x)) true ")
   (ht-append
   (tt "                  else ") (colorize (tt "exists(p, xs)") "green"))
   (tt "  }")))
  )
 )

(define fact
  (vl-append
    (tt "def fact(n:Int): Int = ")
    (tt "  if(n==1) 1 else n * fact(n-1)")))

;;;;;;;;;; NOT TAIL RECURSION ;;;;;;;;;;
(slide 
 (para #:align 'center (large-text "Not Tail Recursion"))
 (blank 50)
 'alts
 (list
  (list fact)
  (list
   (vl-append
    (tt "def fact(n:Int): Int = ")
    (ht-append (tt "  if(n==1) 1 else n ") (colorize (tt "*") "red") (tt " fact(n-1)")))
   )
  )
 )

(slide easier-to-understand-exists)
;(slide basic-exists)

;;;;;;;;;; DISPLAY THE STACK FOR A CALL TO EXISTS ;;;;;;;;;;
(define stack-for-exists (list   
  (tt "ret=exists:6, p=_==5, list=[5]")
  (tt "ret=exists:6, p=_==5, list=[4,5]")
  (tt "ret=exists:6, p=_==5, list=[3,4,5]")
  (tt "ret=exists:6, p=_==5, list=[2,3,4,5]")
  (tt "ret=main:5,   p=_==5, list=[1,2,3,4,5]")
))

(define huge-stack-for-exists (list   
  (tt "ret=exists:6, p=_==1000000, list=[1000000]   ")
  (tt "...")
  (tt "ret=exists:6, p=_==1000000, list=[4..1000000]")
  (tt "ret=exists:6, p=_==1000000, list=[3..1000000]")
  (tt "ret=exists:6, p=_==1000000, list=[2..1000000]")
  (tt "ret=main:5,   p=_==1000000, list=[1..1000000]")
))

#;(define huge-stack-for-exists (list   
  (tt "exists(p=_==1000000, list=[1000000])   ")
  (tt "...")
  (tt "exists(p=_==1000000, list=[4..1000000])")
  (tt "exists(p=_==1000000, list=[3..1000000])")
  (tt "exists(p=_==1000000, list=[2..1000000])")
  (tt "exists(p=_==1000000, list=[1..1000000])")
))

(define stack-overflow (list   
  (colorize (tt "WRONG! StackOverflowError") "red")
  (tt "...")
  (tt "ret=exists:6, p=_==1000000, list=[4..1000000]")
  (tt "ret=exists:6, p=_==1000000, list=[3..1000000]")
  (tt "ret=exists:6, p=_==1000000, list=[2..1000000]")
  (tt "ret=main:5,   p=_==1000000, list=[1..1000000]")
 ))

(forward-call-stack "Activaton Records" stack-for-exists)
(rewind-call-stack "Activaton Records" stack-for-exists)

(forward-call-stack "Stack Trace" huge-stack-for-exists)
(display-stack "Stack Trace" stack-overflow 0)


;;;;;;;;;; EXISTS IMPL WITH WHILE ;;;;;;;;;;
(slide 
 (para #:align 'center (large-text "Can we fix this?"))
 (blank 50)
 basic-exists)

(slide 
 (para #:align 'center (large-text "Sort of..."))
 'next
 (blank 50)
 (vl-append
   (tt "def existsW[T](p:T=>Boolean,")
   (tt "               list:List[T]): Boolean = {")
   (tt "  var tmp = list")
   (tt "  while(tmp!=Nil){")
   (tt "    if(p(tmp.head)) return true")
   (tt "    tmp = tmp.tail")
   (tt "  }")
   (tt "  false")
   (tt "}"))
)

(slide 
  (para #:align 'center (large-text "Activation Record"))
  (blank 50)(left-align (tt "ret=main:5,   p=_==1000000, list=[1..1000000]")))

;(tail-call-stack (reverse stack-for-exists))

(slide 
 (para #:align 'center (large-text "scalac"))
 (blank 50)
 (t "scalac automatically converts tail recursion into a while loop")
 'next
 (t "in some situations")
 )

(slide 
 (para #:align 'center (large-text "Example"))
 (blank 50)
 (vl-append
   ;(tt "@scala.annotation.tailrec")
   (tt "object Millions {")
   (tt "  def makeAMillion(n:Int): Int =")
   (tt "    if(n==1000000) n")
   (tt "    else makeAMillion(n+1)")
   (tt "}")))


(slide 
 (para #:align 'center (large-text "Decompiled Java"))
 (blank 50)
 (vl-append
   (tt "public final int incrementToOneMillion(int n) {")
   (tt "  while (true) {")
   (tt "    if (n == 1000000) return n;")
   (tt "    n += 1;")
   (tt "  }")
   (tt "}")))

(slide 
 (para #:align 'center (large-text "@tailrec"))
 (blank 50)
 (t "But...I've heard about @tailrec, now I'm confused."))

(slide 
 (para #:align 'center (large-text "@tailrec"))
 (blank 50)
 (para #:align 'left
 (t "http://www.scala-lang.org/api/current/scala/annotation/tailrec.html:")
 (blank 50)
 (t "'A method annotation which verifies that the method will be")
 (t "compiled with tail call optimization. If it is present, the") 
 (t "compiler will issue an error if the method cannot be optimized ")
 (t "into a loop.'")))

(slide 
 (para #:align 'center (large-text "Example"))
 (blank 50)
 (vl-append
   ;(tt "@scala.annotation.tailrec")
   (tt "object Millions {")
   (tt "  def makeAMillion(n:Int): Int =")
   (tt "    if(n==1000000) n")
   (tt "    else makeAMillion(n+1)")
   (tt "}")))

(slide 
 (para #:align 'center (large-text "Example"))
 (blank 50)
 (vl-append
   (tt "object Millions {")
   (colorize (tt "  @scala.annotation.tailrec") "green")
   (tt "  def makeAMillion(n:Int): Int =")
   (tt "    if(n==1000000) n")
   (tt "    else makeAMillion(n+1)")
   (tt "}")))

(slide 
 (para #:align 'center (large-text "Example"))
 (blank 50)
 (vl-append
   (ht-append (colorize (tt "class") "green") (tt " Millions {"))
   (tt "  @scala.annotation.tailrec")
   (tt "  def makeAMillion(n:Int): Int =")
   (tt "    if(n==1000000) n")
   (tt "    else makeAMillion(n+1)")
   (tt "}")))

(slide 
 (para #:align 'center (large-text "Error"))
 (blank 50)
 (vl-append
   (t "could not optimize @tailrec annotated method makeAMillion:")
   (t "it is neither private nor final so can be overridden")))

(slide 
 (para #:align 'center (large-text "Example"))
 (blank 50)
 (vl-append
   (tt "class Millions {")
   (tt "  @scala.annotation.tailrec")
   (tt "  final def makeAMillion(n:Int): Int =")
   (tt "    if(n==1000000) n")
   (tt "    else makeAMillion(n+1)")
   (tt "}")))


(slide 
 (para #:align 'center (large-text "Example"))
 (blank 50)
 (vl-append
  (tt "object Millions {")
   (tt "  @scala.annotation.tailrec")
   (tt "  def makeAMillion(n:Int): Int =")
   (tt "    if(n==1000000) n")
   (tt "    else if(util.Random.nextInt(100) == 42)")
   (tt "      error(\"boom\")")
   (tt "    else makeAMillion(n+1)")
   (tt "}")))

(slide 
 (para #:align 'center (large-text "Stack Trace?"))
 (blank 50)
 (vl-append
   (tt "java.lang.RuntimeException: boom")
   (tt "at scala.sys.package$.error(package.scala:27)")
   (tt "at scala.Predef$.error(Predef.scala:66)")
   (tt "at Millions$.makeAMillion2(MillionS.scala:13)")
   (tt "at Millions$.main(MillionS.scala:4)")
   (tt "at Millions.main(MillionS.scala)")))

;;;;;;;;;;;;;;;;;;;;;;;
(slide 
 (para #:align 'center (large-text "Mutually Recursive Tail Call"))
 (blank 50)
 'alts
 (list
  (list (vl-append
    (tt "def even(n:Int): Int =")
    (tt "  if(n==0) true else odd(n-1)")
    (tt "")
    (tt "def odd(n:Int): Int =")
    (tt "  if(n==0) false else even(n-1)")))
  (list (vl-append
    (tt "def even(n:Int): Int =")
    (ht-append (tt "  if(n==0) true else ") (colorize (tt "odd(n-1)") "green"))
    (tt "")
    (tt "def odd(n:Int): Int =")
    (ht-append (tt "  if(n==0) false else ") (colorize (tt "even(n-1)") "green"))))))

;;;;;;;;;; OLD JUNK WORTH SAVING FOR REFERENCE ;;;;;;;;;;

#;(slide
 #:title "Compile Function"
 (item (t "compile :: String -> String"))
 'next
 (subitem (t "read :: String -> Any  ;; an s-expression"))
 'next
 (subitem (t "parse :: Any -> L4"))
 'next
 (subitem (t "changeVarNames :: L4 -> L4"))
 'next
 (subitem (t "find :: E -> Context -> E"))
 'next
 (subitem (t "fill :: E -> Context -> E"))
 'next
 (subitem (t "print :: L4 -> String"))
 )

#;(slide
 #:title "L4 In Racket: Fill"
 (code 
(define (fill d k)
  (type-case context k
    [let-ctxt (x b k) `(let ([,x ,d]),(find b k))]
    [if-ctxt (t e k) 
     (maybe-let d (λ (v) 
       `(if ,v ,(find t k) ,(find e k))))]
    [en-ctxt (es vs k)
      (maybe-let d 
        (λ (v) 
          (define vs* (append vs (list v)))
          (match es
            ['() (fill vs* k)]
            [(cons e es*) 
             (find e (en-ctxt es* vs* k))])))]
    [no-ctxt () d]))))


#;(slide
 #:title "L4 Compiler Class Diagram"
 (bitmap "/Users/josh/Downloads/L4_1.png")
 )
