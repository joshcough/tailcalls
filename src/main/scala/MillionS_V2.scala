object MillionS_V2 { 
  def main(args:Array[String]) {
    println(new MillionS_V2().incrementToOneMillion(0))
  }
}

class MillionS_V2 {
  final def incrementToOneMillion(n:Int): Int =
    if(n<1000000) incrementToOneMillion(n+1) else n
}
/**
object MillionS_V2_Extender {                   
  def main(args:Array[String]) {
    println(new MillionS_V2_Extender().incrementToOneMillion(0))
  }
}

class MillionS_V2_Extender extends MillionS_V2{
  override def incrementToOneMillion(n:Int): Int =
    if(n<999999) error("i dont like 9s")
    else super.incrementToOneMillion(n)
}
**/
