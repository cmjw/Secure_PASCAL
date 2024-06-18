//       GSN    14 Oct 08
// 

final class associative
{
    public static void main(String args[]) {
        double a = 1.0;
        double e = 1.0e-15;
        if ( (a + (e + e)) == ((a + e) + e) )
            System.out.println("Worked for this case.");
        else System.out.println("Floating + is not associative.");
   }
}
