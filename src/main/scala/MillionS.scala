class MillionS{ 
  def main(args:Array[String]) {
    println(makeAMillion(0))
    println(makeAMillion2(0))
  }

  @scala.annotation.tailrec
  def makeAMillion(n:Int): Int = if(n==1000000) n else makeAMillion(n+1)

  @scala.annotation.tailrec
  def makeAMillion2(n:Int): Int = 
    if(n==1000000) n 
    else if(util.Random.nextInt(100) == 42) error("boom")
    else makeAMillion2(n+1)
}


