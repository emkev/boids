
/* 2016.06.17 , a target for boid's arrival */

class targetForArrival
{
  PVector location ;
  
  targetForArrival(float x , float y)
  {
    location = new PVector(x , y);
  }
  
  void display()
  {
    ellipse(location.x , location.y , 16 , 16);
  }
}
