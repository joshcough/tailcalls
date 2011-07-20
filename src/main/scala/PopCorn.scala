object PopCorn {

  trait PopCorn
  case object Plain extends PopCorn
  case class Salted(p:PopCorn) extends PopCorn
  case class Buttered(p:PopCorn) extends PopCorn
 
  def main(args:Array[String]) {
    println("munching on: " + SaltyButteryNormalCalls.askMrSalt) 
    println("munching on: " + PlainPopcornNormalCalls.askMrSalt) 
    println("munching on: " + PlainPopcornTailCalls.askMrSalt.result) 
  }

  object SaltyButteryNormalCalls {
    def askMrSalt = Salted(askMrButter) 
    def askMrButter = Buttered(askMrPopper)
    def askMrPopper = Plain
  }

  object PlainPopcornNormalCalls {
    def askMrSalt = askMrButter                           
    def askMrButter = askMrPopper
    def askMrPopper = "plain popcorn"
  }

  object PlainPopcornTailCalls {
    import scala.util.control.TailCalls._
    def askMrSalt = tailcall(askMrButter)       
    def askMrButter = tailcall(askMrPopper)
    def askMrPopper = done("plain popcorn")
  }
}
