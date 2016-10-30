# boids


class boid :

  location , velocity , acceleration , maxspeed , maxforce ,       物理运动相关
  update( ) , applyforce( ) , display( ) , checkedge( ) ,

  separate( ArrayList<boid> ) :          
  align( ArrayList<boid> ) :
  cohesion( ArrayList<boid> ) : 

  flock( ArrayList<boid> ) :             综合应用三个动力操作
    applyforce (   separate( )*s-weight  ,   align( )*a-weight  ,   cohesion( )*c-weight  ,    ) ;

  run( ArrayList<boid> ) :
     flock ( boids ) ;                        调用 flock ( ) 
     update( ) , checked( ) , display( ) ,



class flock :

  build ArrayList<boid> ,          构建 boids
  addBoid ( ) : add each boid ,

  run ( ) : each   boid .run( ) ;       逐个运行每个 boid.run( ) 



main :

  flock .addBoid 

  flock .run ( ) ;

