/*
20150724  16:31
*/

class flock
{
  ArrayList<boid> boids ; 

  flock()
  {
    boids = new ArrayList<boid>() ; 
  }

  void addBoid(boid b)
  {
    boids.add(b) ; 
  }

  void run()
  {
    for(boid b : boids)
    {
      b.run(boids) ; 
    }
  }

}
