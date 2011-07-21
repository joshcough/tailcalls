#lang slideshow

(require slideshow/code)
(require scheme/pretty)

(define (large-text txt)
  (text txt (current-main-font) 62))

(define (small-text txt)
  (text txt (current-main-font) 22))


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
 (vc-append 0 (t "Northwestern University"))
 (tt "")
 (vc-append 0 (t "http://jackcoughonsoftware.blogspot.com/"))
 (vc-append 0 (t "https://github.com/joshcough"))
)

(slide
 (para #:align 'center (large-text "What Will I Learn"))
 (blank 50)
 (item (t "Learn what tail calls are"))
 (item (t "Learn to avoid stack overflow on the JVM"))
 (subitem (t "with scalac"))
 (subitem (t "with @tailrec"))
 (subitem (t "with trampolining"))
)

;;;;;;;;;; TAIL CALL EXAMPLE ;;;;;;;;;;
(slide 
 (para #:align 'center (large-text "Definitions"))
 (blank 25)
 (item (t "Tail Call"))
 (para #:align 'left 
  (t "    When the last thing a function does is call")
  (t "    another function, and return that functions result.")
  )
 'next
  (item (t "Direct Tail Recursion"))
 (para #:align 'left 
  (t "    Tail call, but with callee == caller.")
  )
 'next
 (item (t "Tail Call Optimization"))
 (para #:align 'left 
  (t "    Don't consume stack space for tail calls.")
  ;(t "    Just use goto instead.")
  )
)

(slide 
 (para #:align 'center (large-text "Tail Call Example"))
 (blank 50)
 (vl-append
    (tt "def x() = {")
    (tt "  y() // regular call")
    (tt "  z() // tail call")
    (tt "}")
 ))

(slide 
 (para #:align 'center (large-text "Tail Call Example"))
 (blank 50)
 (vl-append
    (tt "def x(i:Int) {")
    (tt "  if(i==5) y() // tail call")
    (tt "  else z()     // tail call")
    (tt "}")
 ))

(slide 
 (para #:align 'center (large-text "Not a Tail Call"))
 (blank 50)
 (vl-append
    (tt "def x(): Int = {")
    (tt "  y() // regular call")
    (tt "  z() // regular call")
    (tt "  7   // not a call.")
    (tt "}")
 ))

;;;;;;;;;; TAIL RECURSION EXAMPLES ;;;;;;;;;;

(define fact
  (vl-append
    (tt "def fact(n:Int): Int = ")
    (tt "  if(n==1) 1 else n * fact(n-1)")))

;;;;;;;;;; NOT TAIL RECURSION ;;;;;;;;;;
(slide 
 (para #:align 'center (large-text "Tail Recursion?"))
 (blank 50)
 fact
 )

(slide 
 (para #:align 'center (large-text "Not Tail Recursion!"))
 (blank 50)
 (vl-append
  (tt "def fact(n:Int): Int = ")
  (ht-append (tt "  if(n==1) 1 else n ") (colorize (tt "*") "red") (tt " fact(n-1)")))
 )


;;;;;;;;;;  ;;;;;;;;;;
(slide 
 (para #:align 'center (large-text "Can We Fix It...?"))
 'next
 (para #:align 'center (t "Here's an ugly way."))
 (blank 50)
 'next
 (vl-append
   (tt "def fact(n:Int): Int = {")
   (tt "  var tmp = n")
   (tt "  var acc = 1")
   (tt "  while(tmp>1) {")
   (tt "    acc = tmp * acc")
   (tt "    tmp -= 1")
   (tt "  }")
   (tt "  acc")
   (tt "}")
  ) 
)
  
(slide 
 (para #:align 'center (large-text "Can We Fix It...?"))
 'next
 (para #:align 'center (t "There's a nicer way:"))
 (para #:align 'center (t "Refactor to tail recursion."))
 (blank 50)
 'next
 (vl-append
   (tt "def fact(n:Int, acc:Int=1): Int =  ")
   (tt "  if(n==1) acc else fact(n-1, n * acc)")
  ) 
)

(slide 
 (para #:align 'center (large-text "But..."))
 'next
 (para #:align 'center (t "The JVM doesn't support tail calls."))
 (para #:align 'center (t "So how does this help?"))
)
 
(slide 
 (para #:align 'center (large-text "scalac helps"))
 (blank 50)
 (t "scalac automatically converts tail recursion into a loop*")
 'next
 (t "* in some situations (I'll explain)")
 )

(slide 
 (para #:align 'center (large-text "Let's decompile this"))
 (blank 50)
 (vl-append
   (tt "object Fact {")
   (tt "  def fact(n:Int, acc:Int=1): Int =  ")
   (tt "    if(n==1) acc else fact(n-1, n * acc)")
   (tt "}")
  ) 
)

(slide 
 (para #:align 'center (large-text "Decompiled Java"))
 (blank 50)
 (vl-append
   (tt "public int fact(int n, int acc) {")
   (tt "  while (true) {")
   (tt "    if (n == 1) return acc;") 
   (tt "    acc = n * acc;")
   (tt "    n -= 1;")
   (tt "  }")
   (tt "}")
 ))

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
 (para #:align 'center (large-text "Fact again"))
 (blank 50)
 (vl-append
   (tt "object Fact {")
   (tt "  def fact(n:Int, acc:Int=1): Int =  ")
   (tt "    if(n==1) acc else fact(n-1, n * acc)")
   (tt "}")
  ) 
)

(slide 
 (para #:align 'center (large-text "Adding @tailrec"))
 (blank 50)
 (vl-append
   (tt "object Fact {")
   (colorize (tt "  @scala.annotation.tailrec") "green")
   (tt "  def fact(n:Int, acc:Int=1): Int =  ")
   (tt "    if(n==1) acc else fact(n-1, n * acc)")
   (tt "}")
))

(slide 
 (para #:align 'center (large-text "Change object to class"))
 (blank 50)
 (vl-append
   (ht-append (colorize (tt "class") "green") (tt " Fact {"))
   (tt "  @scala.annotation.tailrec")
   (tt "  def fact(n:Int, acc:Int=1): Int =  ")
   (tt "    if(n==1) acc else fact(n-1, n * acc)")
   (tt "}")
))

(slide 
 (para #:align 'center (large-text "Error"))
 (blank 50)
 (vl-append
   (t "could not optimize @tailrec annotated method fact:")
   (t "it is neither private nor final so can be overridden")))

(slide 
 (para #:align 'center (large-text "Recall the original fact"))
 (blank 50)
 (vl-append
   (tt "object Fact {")
   (tt "  def fact(n:Int): Int =  ")
   (tt "    if(n==1) 1 else n * fact(n-1)")
   (tt "}")
))

(slide 
 (para #:align 'center (large-text "Recall the original fact"))
 (blank 50)
 (vl-append
   (tt "object Fact {")
   (colorize (tt "  @scala.annotation.tailrec") "green")
   (tt "  def fact(n:Int): Int =  ")
   (tt "    if(n==1) 1 else n * fact(n-1)")
   (tt "}")
))

(slide 
 (para #:align 'center (large-text "Error"))
 (blank 50)
 (vl-append
   (t "could not optimize @tailrec annotated method fact:")
   (t "it contains a recursive call not in tail position")))

;;;;;;;;;;;;;;;;;;;;;;;

(define evenodd
  (vl-append
    (tt "def even(n:Int): Int =")
    (tt "  if(n==0) true else odd(n-1)")
    (tt "")
    (tt "def odd(n:Int): Int =")
    (tt "  if(n==0) false else even(n-1)")))

(slide 
 (para #:align 'center (large-text "Trampolining"))
 (blank 50)
 (tt "scala.util.control.TailCalls")
 )

(slide 
 (para #:align 'center (large-text "Recall"))
 (blank 50)
 (vl-append
 (tt "object PlainPopcornNormalCalls {")
 (tt "  def main = println(\"yum: \" + askMrSalt)")
 (tt "  def askMrSalt = askMrButter")
 (tt "  def askMrButter = askMrPopper")
 (tt "  def askMrPopper = \"plain popcorn\"")
 (tt "}")))

(slide 
 (para #:align 'center (large-text "Trampolining"))
 (blank 50)
 (vl-append
 (colorize (tt "import scala.util.control.TailCalls._") "green")
 (tt "")
 (tt "object PlainPopcornTailCalls {")
 (ht-append (tt "  def main = println(\"yum: \" + askMrSalt") (colorize (tt ".result") "green") (tt ")"))
 (ht-append (tt "  def askMrSalt = ") (colorize (tt "tailcall(") "green") (tt "askMrButter") (colorize (tt ")") "green"))
 (ht-append (tt "  def askMrButter = ") (colorize (tt "tailcall(") "green") (tt "askMrPopper") (colorize (tt ")") "green"))
 (ht-append (tt "  def askMrPopper = ") (colorize (tt "done(") "green") (tt "\"plain popcorn\"") (colorize (tt ")") "green"))
 (tt "}")))

(slide 
 (para #:align 'center (large-text "Trampolining"))
 (blank 50)
 (vl-append
 (tt "import scala.util.control.TailCalls._")
 (tt "")
 (tt "object PlainPopcornTailCalls {")
 (tt "  def main = println(\"yum: \" + askMrSalt.result)")
 (tt "  def askMrSalt = tailcall(askMrButter)")
 (tt "  def askMrButter = tailcall(askMrPopper)")
 (tt "  def askMrPopper = done(\"plain popcorn\")")
 (tt "}")))

(slide 
 (para #:align 'center (large-text "Indirect Recursive Tail Call"))
 (blank 50)
 (vl-append
    (tt "def even(n:Int): Boolean =")
    (tt "  if(n==0) true") 
    (tt "  else odd(n-1)")
    (tt "")
    (tt "def odd(n:Int): Boolean =")
    (tt "  if(n==0) false") 
    (tt "  else even(n-1)")))

(define evenodd-tc
  (vl-append
    (tt "import scala.util.control.TailCalls._")
    (tt " ")
    (tt "def even(n:Int): TailRec[Boolean] =")
    (tt "  if(n==0) done(true)")
    (tt "  else tailcall(odd(n-1))")
    (tt "")
    (tt "def odd(n:Int): TailRec[Boolean] =")
    (tt "  if(n==0) done(false)")
    (tt "  else tailcall(even(n-1))")
))

(slide 
 (para #:align 'center (large-text "Trampolining"))
 (blank 50)
 evenodd-tc
 )


(slide
 (para #:align 'center (large-text "References"))
 (blank 50)
 (para #:align 'left
 (item (small-text "Lambda: the ultimate goto"))
 (subitem (small-text "http://repository.readscheme.org/ftp/papers/ai-lab-pubs/AIM-443.pdf"))
 (item (small-text "Fortress Blog - ObjectOrientedTailRecursion"))
 (subitem (small-text "http://tinyurl.com/yjbgks3"))
 (item (small-text "Jack Cough On Software - Tail Calls, Tail Recursion, TCO"))
 (subitem (small-text "http://jackcoughonsoftware.blogspot.com/2011/07/tail-calls-tail-recursion-tco.html"))
 (item (small-text "Rich Dougherty - Tail Calls, Tail Rec, Trampolines"))
 (subitem (small-text "http://blog.richdougherty.com/2009/04/tail-calls-tailrec-and-trampolines.html"))
 (item (small-text "John Rose - Tail Calls in the JVM"))
 (subitem (small-text "http://blogs.oracle.com/jrose/entry/tail_calls_in_the_vm"))
 (item (small-text "Matthias Felleisen - A Tail-Recursive Machine with Stack Inspection"))
 (subitem (small-text "http://www.ccs.neu.edu/scheme/pubs/cf-toplas04.pdf"))
 (item (small-text "Stack Overflow - @tailrec and non-final methods"))
 (subitem (small-text "   http://bit.ly/stacko-tailrec"))
))

;;;;;;;;;; OLD JUNK WORTH SAVING FOR REFERENCE ;;;;;;;;;;

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

#;(slide 
 (para #:align 'center (large-text "Tail Call Optimization"))
 (blank 50)
 (item "Replacing")
  (subitem (tt "stack.push(...)"))
  (subitem (tt "goto function"))
  (subitem (tt "mov $RV $RV"))
  (subitem (tt "goto stack.pop()"))
  (item "With")
  (subitem "goto function")
)
