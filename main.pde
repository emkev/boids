/* code for flocking , start */
/*
flock f ; 

void setup()
{
  size(640 , 480) ; 
  f = new flock() ; 
  for(int i = 0 ; i < 100 ; i++)
  {
    f.addBoid(new boid(random(0 , 600) , random(0 , 400))) ; 
  }
}

void draw()
{
  background(200) ; 
  f.run() ; 
}
*/
/* code for flocking , end */

/* 2016.06.17 , single boid for a target , start */
/*
boid b ;
targetForArrival t ;

void setup()
{
  size(640 , 480);
  b = new boid(480 , 320);
  t = new targetForArrival(320 , 240);
}

void draw()
{
  background(200);
  b.applyforce(b.seek(t.location));
  b.update();
  b.checkedge();
  
  t.display();
  b.display();
}
*/
/* single boid for a target , end */

/* follow path , start */
path p ;
boid b ;

void setup()
{
  size(640 , 480);
  p = new path();
  b = new boid(500 , 240);
}

void draw()
{
  background(255);
  b.follow(p);
  b.checkedge();
  b.update();
  
  b.display();
  p.display();
}
/* follow path , end */
