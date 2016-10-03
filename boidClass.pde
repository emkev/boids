
/* boid
20150723  19:31 start
20150724  
20151008  23:29
*/
class boid
{
  PVector location ; 
  PVector velocity ; 
  PVector acceleration ; 

  float r ; 
  float maxspeed ; 
  float maxforce ; 

  boid(float x , float y)
  {
    location = new PVector(x , y) ; 
    velocity = new PVector(0 , 0) ; 
    acceleration = new PVector(0 , 0) ; 

    r = 3.0 ; 
    maxspeed = 4 ; 
    maxforce = 0.1 ; 
  }

  void update()
  {
    velocity.add(acceleration) ; 
    velocity.limit(maxspeed) ; 
    location.add(velocity) ; 
    acceleration.mult(0) ; 
  }

  void applyforce(PVector force)
  {
    acceleration.add(force) ; 
  }

  PVector seek(PVector target)
  {
    PVector desired = PVector.sub(target , location) ; 
    desired.normalize() ; 
    float d = PVector.dist(location , target) ; 

    if(d < 100)
    {
      desired.mult(map(d , 0 , 100 , 0 , maxspeed)) ; 
    }
    else
    {
      desired.mult(maxspeed) ; 
    }

    PVector steer = PVector.sub(desired , velocity) ; 
    steer.limit(maxforce) ; 
    return steer ; 
  }

  void display()
  {
    float theta = velocity.heading2D() + PI / 2 ; 
    fill(175) ; 
    stroke(0) ; 
    pushMatrix() ; 
    translate(location.x , location.y) ; 
    rotate(theta) ; 
    beginShape() ; 
    vertex(0 , -r * 2) ; 
    vertex(-r , r * 2) ; 
    vertex(r , r * 2) ; 
    endShape(CLOSE) ; 
    popMatrix() ; 
  }
  
  void checkedge()
  {
    if((location.x < 0) || (location.x > width))
    {
      velocity.x *= -1 ;
    }
    if((location.y < 0) || (location.y > height))
    {
      velocity.y *= -1 ;
    }
  }

  void follow(path p)
  {
    PVector predict = velocity.get() ; 
    predict.normalize() ; 
    predict.mult(25) ; 
    PVector predictLoc = PVector.add(location , predict) ; 

    PVector a = p.start ; 
    PVector b = p.end ; 
    PVector normalpoint = getNormalPoint(predictLoc , a , b) ; 

    PVector dir = PVector.sub(b , normalpoint) ; 
    dir.normalize() ; 
    dir.mult(25) ; 
    PVector target = PVector.add(normalpoint , dir) ; 

    float distance = PVector.dist(predictLoc , normalpoint) ; 
    if(distance > p.radius)
    {
      PVector force = seek(target) ; 
      applyforce(force) ; 
    }
  }

  PVector getNormalPoint(PVector p , PVector a , PVector b)
  {
    PVector ap = PVector.sub(p , a) ; 
    PVector ab = PVector.sub(b , a) ; 
    float c = ap.dot(ab) ; 
    ab.normalize() ; 
    ab.mult(c) ; 
    PVector normalpoint = PVector.add(a , ab) ; 
    return normalpoint ; 
  }

  void followMultipePath(ArrayList<PVector> paths)
  {
    float dist = 10000 ; 
/* 
    PVector target = new PVector(0 , 0) ; 
wrong , if there is not new value into target , PVector(0 , 0) will be used as moving target and apply force . 
*/
    PVector target = null ; 

    PVector predict = velocity.get() ; 
    predict.normalize() ; 
    predict.mult(25) ; 
    PVector predictLoc = PVector.add(location , predict) ; 

    for(int i = 0 ; i < paths.size() - 1 ; i++)
    {
      PVector a = paths.get(i) ; 
      PVector b = paths.get(i + 1) ; 
      PVector normalpoint = getNormalPoint(predictLoc , a , b) ; 

      if((normalpoint.x > a.x) || (normalpoint.x < b.x))
      {
        float distance = PVector.dist(predictLoc , normalpoint) ; 
        if(distance < dist)
        {
          PVector dir = PVector.sub(b , normalpoint) ; 
          dir.normalize() ; 
          dir.mult(10) ; 
          PVector dirforward = PVector.add(normalpoint , dir) ; 
          target = dirforward.get() ; 
          dist = distance ; 
        }
      }
    }
    PVector force = seek(target) ; 
    applyforce(force) ; 
  }

/* 
20150724  13:43
*/

  PVector separate(ArrayList<boid> boids)
  {
    float desiredseparation = r * 2 ; 
    PVector sum = new PVector(0 , 0) ; 
    int count = 0 ; 

    for(boid other : boids)
    {
      float d = PVector.dist(location , other.location) ; 
      if((d > 0) && (d < desiredseparation))
      {    
        PVector diff = PVector.sub(location , other.location) ; 
        diff.normalize() ; 
        sum.add(diff) ; 
        count++ ; 
      }
    }
    if(count > 0)
    {
      sum.div(count) ; 
      sum.normalize() ; 
      sum.mult(maxspeed) ; 

      PVector steer = PVector.sub(sum , velocity) ; 
      steer.limit(maxforce) ; 
      return steer ; 
    }
    else
    {
      return new PVector(0 , 0) ; 
    }
  }

  PVector align(ArrayList<boid> boids)
  {
    float neighbordist = 50 ;  
    PVector sum = new PVector(0 , 0) ; 
    int count = 0 ; 

    for(boid other : boids)
    {
      float d = PVector.dist(location , other.location) ; 
      if((d > 0) && (d < neighbordist))
      {
        sum.add(other.velocity) ; 
        count++ ; 
      }
    }

    if(count > 0)
    {
      sum.div(count) ; 
      sum.normalize() ; 
      sum.mult(maxspeed) ; 

      PVector steer = PVector.sub(sum , velocity) ; 
      steer.limit(maxforce) ; 
      return steer ; 
    }
    else
    {
      return new PVector(0 , 0) ; 
    }
  }

  PVector cohesion(ArrayList<boid> boids)
  {
    float neighbordist = 50 ; 
    PVector sum = new PVector(0 , 0) ; 
    int count = 0 ; 

    for(boid other : boids)
    {
      float d = PVector.dist(location , other.location) ; 
      if((d > 0) && (d < neighbordist))
      {
        sum.add(other.location) ; 
        count++ ; 
      }
    }

    if(count > 0)
    {
      sum.div(count) ; 
      PVector steer = seek(sum) ; 
      return steer ; 
    }
    else
    {
      return new PVector(0 , 0) ; 
    }
  }

  void flock(ArrayList<boid> boids)
  {
    PVector sep = separate(boids) ; 
    PVector ali = align(boids) ; 
    PVector coh = cohesion(boids) ; 
    
    // 20151008 , add seeking mouse . 
    PVector mouse = new PVector(mouseX , mouseY);
    PVector sk = seek(mouse);

    /* 2015.12.10 , 
       for suitable situation , weight for centering (coh) can 
       not be large , and weight for avoidance (sep) can be much 
       larger . And the suitable situation means that by my 
       observation . 
     */
    sep.mult(0.4) ; 
    ali.mult(0.4) ; 
    coh.mult(0.2) ; 
    
    sk.mult(1.0);
    
    applyforce(sep) ; 
    applyforce(ali) ; 
    applyforce(coh) ; 
    
    //applyforce(sk);
  }

  void run(ArrayList<boid> boids)
  {
    flock(boids) ; 
    update() ; 
    checkedge() ; 
    display() ; 
  }

}
