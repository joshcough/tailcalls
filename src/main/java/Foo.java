public class Foo {

  static public void main(String[] args){
    System.out.println(incrementToOneMillion(0));
  }

  static int incrementToOneMillion(int n) {
    if(n<1000000) return incrementToOneMillion(n+1); 
    else return n;
  }

}
