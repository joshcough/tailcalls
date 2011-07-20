object Exists {

  def exists[T](p:T=>Boolean, list:List[T]): Boolean = 
    list match {
      case Nil => false
      case x::xs => if(p(x)) true else exists(p, xs)
    }

  def existsUsingWhile[T](p:T=>Boolean, list:List[T]): Boolean = {
    var tmp = list
    while(tmp!=Nil){ 
      if(p(tmp.head)) return true
      tmp = tmp.tail
    }
    false
  }

  def even(n:Int): Boolean =
    if(n==0) true else odd(n-1)

  def odd(n:Int): Boolean =
    if(n==0) false else even(n-1)

  def fact(n:Int): Int =
    if(n==1) 1 else n * fact(n-1)

  def main(args:Array[String]) {
    assert(exists[Int](_==5, List(1,2,3,4,5)) == true)
    assert(existsUsingWhile[Int](_==5, List(1,2,3,4,5)) == true)
  }
}
