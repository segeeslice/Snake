import java.util.*;

// Total grid is 500 x 500
// Grid is 25 x 25 with boxes of size 20
final int PADDING = 1;
final int BOX_SIZE = 20-(2*PADDING);

// Based on 0-indexed 25x25 grid
class SnakePoint {
  int x;
  int y;
  
  SnakePoint (int x_in, int y_in) {
    x = x_in;
    y = y_in;
  }
  
  int getX () { return x; }
  int getY () { return y; }
  void setX (int x_in) { x = x_in; }
  void setY (int y_in) { y = y_in; }
  
  int getXCoord () { return x*20 + 1; }
  int getYCoord () { return y*20 + 1; }
}

class Snake {
  private Vector<SnakePoint> body;
  private char direction;
  
  Snake () {
    body = new Vector<SnakePoint> ();
    direction = 'R';
    
    for (int i = 6; i >= 0; i--) {
      body.add(new SnakePoint(i, 0));
    }
  }
  
  List<SnakePoint> getBody () { return body; }
  
  void moveAuto () { move(direction); }
  void setDirection (char d) { direction = d; }
  
  void move(char mode) {    
    SnakePoint s = body.get(0);
    int lastX = s.getX();
    int lastY = s.getY();
    
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
    
    body.set(0, s);
    
    // Move remaining items to follow front
    moveNext(1, lastX, lastY);
  }
  
  private void moveNext (int i, int x, int y) {
    if (i < body.size()) {
      SnakePoint s = body.get(i);
      int lastX = s.getX();
      int lastY = s.getY();
      
      s.setX(x);
      s.setY(y);
      
      body.set(i, s);
      moveNext(i+1, lastX, lastY);
    }
  }
}

Snake snake;

void setup () {
  size(500, 500);
  background(100);
  stroke(255);
  fill(255);
  rectMode(CORNER);
  frameRate(60);
  
  snake = new Snake ();
}

void draw () {
  background(100);
  
  for (SnakePoint p : snake.getBody()) {
    rect(p.getXCoord(), p.getYCoord(), BOX_SIZE, BOX_SIZE);
  }
  
  if (frameCount % 5 == 1) {
    snake.moveAuto();
  }
}

void keyPressed () {
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
      
    default:
      println("What?");
  }
}
