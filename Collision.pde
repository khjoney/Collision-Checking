
//Assignment 3
// COMP 3490 (Graphics 1)
// Question 1
// Done BY : Kaiser Joney
// Student ID : 7763080
// Date : Nov 21st 2018
//Professor: JOHN BRAICO
Ball[] balls =  { // Balls Array to store different
  new Ball(100, 400, 20), 
  new Ball(250, 400, 20), 
   new Ball(350, 400, 20) ,
    new Ball(400, 400, 20) ,
     new Ball(450, 400, 20), 
      
};

void setup() {// SetUp method
  size(640, 360);
}

void draw() {// Draw method 
      background(0);

  for (Ball b : balls) {// CHecking for the balls in the array

    b.update();
    b.display();
    //background(#232FF7);
    b.checkBoundaryCollision();// Collision check method
    
    
  }
  
  balls[0].checkCollision(balls[1]);// Checking collision with the balls
  balls[0].checkCollision(balls[2]);
  balls[0].checkCollision(balls[3]);
  balls[1].checkCollision(balls[2]);
  balls[1].checkCollision(balls[3]);
  balls[2].checkCollision(balls[3]);
  balls[2].checkCollision(balls[1]);
  balls[3].checkCollision(balls[1]);
  balls[3].checkCollision(balls[2]);
  balls[3].checkCollision(balls[3]);
  balls[3].checkCollision(balls[0]);
  balls[4].checkCollision(balls[0]);
  balls[4].checkCollision(balls[1]);
  balls[4].checkCollision(balls[2]);
  balls[4].checkCollision(balls[3]);
  
}



class Ball {// Ball Class
  PVector position;
  PVector velocity;

  float radius, m;

  Ball(float x, float y, float r_) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity.mult(3);
    radius = r_;
    m = radius*.1;
  }

  void update() {
    position.add(velocity);
  }

  void checkBoundaryCollision() {// COllision checking method.
    if (position.x > width-radius) {
      position.x = width-radius;
      velocity.x *= -1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
    }
  }

  //A check Collision method from Processing
  void checkCollision(Ball other) {
    PVector distanceVect = PVector.sub(other.position, position);
    float distanceVectMag = distanceVect.mag();
    float minDistance = radius + other.radius;
    
    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.position.add(correctionVector);
      position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      // use 1D conservation of momentum equations to calculate the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);
      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
  }

  void display() {
    noStroke();
    color c = color(255,204,0);
    float redValue = red(c);
    //
    fill(redValue,0,0);
    ellipse(position.x, position.y, radius*2, radius*2);
  }
}
//Processing was initiated by 
