import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class snake extends PApplet {



// Total grid is 500 x 500
// Grid is 25 x 25 with boxes of size 20
// Defined more in SnakeClass

Snake snake = new Snake ();
SnakePoint food = randomFood();
Boolean playing = false;

final int BUTTON_DIAM = 100;
final int FOOD_COLOR = color(250, 50, 50);

public void setup () {
  // Prelim
  
  stroke(255);
  strokeWeight(2);
  background(100);
  
  // Game
  rectMode(CORNER);
  frameRate(60);
  
  // Play button
  ellipseMode(CENTER);
  textSize(40);
  textAlign(CENTER,CENTER);
}

public void draw () {
  if (playing) { // Play the game
    background(100);
    
    // Draw snake
    fill(snake.getColor());
    for (SnakePoint p : snake.getBody()) {
      rect(p.getXCoord(), p.getYCoord(), BOX_SIZE, BOX_SIZE);
    }
    
    // Draw food
    fill(food.getColor());
    rect(food.getXCoord(), food.getYCoord(), BOX_SIZE, BOX_SIZE);
    
    // Only move at certain intervals, but keep framerate high
    // to lessen input latency
    if (frameCount % 5 == 1) {
      playing = snake.moveAuto();
      
      if (snakeEat()) {
        food = randomFood();
        snake.addPoint();
      }
    }
  } else { // Display play button    
    stroke(50);
    if (!mouseOverPlay()) {
      fill(200);
    } else {
      fill (255);
    }
    ellipse(250, 250, BUTTON_DIAM, BUTTON_DIAM);
    
    fill(0);
    text("Play", 249, 245);
    
    stroke(255); // Simply reset stroke after
  }
}

public void keyPressed () {
  switch (keyCode) {
    case UP:
      snake.setDirection('U');
      break;

    case DOWN:
      snake.setDirection('D');
      break;

    case LEFT:
      snake.setDirection('L');
      break;

    case RIGHT:
      snake.setDirection('R');
      break;
  }
}

public void mousePressed () {
  // If play button is pressed
  if (mouseOverPlay()) {
    snake = new Snake();
    food = randomFood ();
    playing = true;
  }
}

// Utility functions

public Boolean mouseOverPlay () {
  float disX = 250 - mouseX;
  float disY = 250 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < BUTTON_DIAM/2 ) {
    return true;
  } else {
    return false;
  }
}

public SnakePoint randomFood () {
  int x = 0;
  int y = 0;
  
  do {
    x = PApplet.parseInt(random(25));
    y = PApplet.parseInt(random(25));
  } while (snakeInterfere(x, y));
  
  return new SnakePoint(x, y, FOOD_COLOR);
}

public Boolean snakeInterfere (int x, int y) {
  for (SnakePoint p : snake.getBody()) {
    if (p.getX() == x && p.getY() == y) { return true; }
  }
  
  return false;
}

public Boolean snakeEat () {
  SnakePoint head = snake.getHead();
  return head.getX() == food.getX() && head.getY() == food.getY();
}
// Total grid is 500 x 500
// Grid is 25 x 25 with boxes of size 20 (not including padding)
// Unfortunately must hardcode dimensions since size(x,y) cannot take variables
final int PADDING = 2;
final int BOX_SIZE = 20-(2*PADDING);
final int SIZE = 25;

final int START_LENGTH = 5;

// Simply store coordinates of one segment of snake
// Based on 0-indexed 25x25 grid
class SnakePoint {
  private int x;
  private int y;
  private int c;
  
  SnakePoint (int x_in, int y_in) {
    x = x_in;
    y = y_in;
    c = color(255);
  }
  
  SnakePoint (int x_in, int y_in, int c_in) {
    x = x_in;
    y = y_in;
    c = c_in;
  }
  
  public int getColor () { return c; }
  public void setColor (int c_in) { c = c_in; }
  
  public int getX () { return x; }
  public int getY () { return y; }
  public void setX (int x_in) { x = x_in; }
  public void setY (int y_in) { y = y_in; }
  
  // Return the coordinates to be displayed
  // Sends top left coordinate, assuming mode CORNER
  public int getXCoord () { return x*20 + PADDING; }
  public int getYCoord () { return y*20 + PADDING; }
}

class Snake {
  private Vector<SnakePoint> body;
  private char direction;
  private char directionLast;
  private int c;
  
  Snake () {
    body = new Vector<SnakePoint> ();
    direction = 'R';
    directionLast = 'R';
    c = color(255);
    
    for (int i = START_LENGTH; i >= 0; i--) {
      body.add(new SnakePoint(i, 0, c));
    }
  }
  
  public List<SnakePoint> getBody () { return body; }
  public SnakePoint getHead () { return body.get(0); }
  public int getColor () { return c; }
  
  public void addPoint() {
    // Coordinate is arbitrary since next move allows it to be drawn anyway
    body.add(new SnakePoint(-1, -1, c)); 
  }
  
  // Only set direction if it is not a direct conflict with the current direction
  public void setDirection (char d) { direction = d; }
  
  private Boolean opposite (char x, char y) {
    return (x == 'U' && y == 'D') ||
           (x == 'D' && y == 'U') ||
           (x == 'R' && y == 'L') ||
           (x == 'L' && y == 'R');
  }
  
  // Only move in direction if it is not a direct conflict with the past direction
  public Boolean moveAuto () {
    if (!opposite(direction, directionLast)) {
      return move(direction);
    } else {
      return move(directionLast);
    }
  }
  
  // Return true or false based on if move is okay
  public Boolean move(char mode) {    
    SnakePoint s = body.get(0);
    int lastX = s.getX();
    int lastY = s.getY();
    
    directionLast = mode;
    
    // Move front item
    switch (mode) {
      case 'U':
        s.setY(lastY - 1);
        break;
      case 'D':
        s.setY(lastY + 1);
        break;
      case 'R':
        s.setX(lastX + 1);
        break;
      case 'L':
        s.setX(lastX - 1);
        break;
      default:
        println("Oopsy whoopsy");
    }
    
    if (hitWall(s.getX(), s.getY())) {
      return false;
    } else {
      body.set(0, s);
      
      // Move remaining items to follow front
      return moveNext(1, lastX, lastY);
    }
  }
  
  private Boolean moveNext (int i, int x, int y) {
    if (hitFront(x, y)) {
      return false;
    } else if (i < body.size()) {
      SnakePoint s = body.get(i);
      int lastX = s.getX();
      int lastY = s.getY();
      
      s.setX(x);
      s.setY(y);
      
      body.set(i, s);
      return moveNext(i+1, lastX, lastY);
    } else {
      return true;
    }
  }
  
  private Boolean hitWall (int x, int y) {
    return x < 0 || x > (SIZE-1) || y < 0 || y > (SIZE-1);
  }
  
  private Boolean hitFront (int x, int y) {
    return x == body.get(0).getX() && y == body.get(0).getY();
  }
}
  public void settings() {  size(500, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "snake" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
