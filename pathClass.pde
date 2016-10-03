
/* follow path 
   20150716  21:55 
   20150717  22:30
   20150718  23:15
*/
class path
{
  PVector start ; 
  PVector end ; 
  float radius ; 

  path()
  {
    start = new PVector(0 , height / 3) ; 
    end = new PVector(width , 2 * height / 3) ; 
    radius = 5 ; 
  }

  void display()
  {
    strokeWeight(radius * 2) ; 
    stroke(0 , 100) ;
    line(start.x , start.y , end.x , end.y) ; 
    strokeWeight(1) ; 
    stroke(0) ;
    line(start.x , start.y , end.x , end.y) ; 
  }
}
