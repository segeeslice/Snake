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
  
  // Return the coordinates to be displayed
  // Sends top left coordinate, assuming mode CORNER
  int getXCoord () { return x*20 + PADDING; }
  int getYCoord () { return y*20 + PADDING; }
}

class Snake {
  private Vector<SnakePoint> body;
  private char direction;
  
  Snake () {
    body = new Vector<SnakePoint> ();
    direction = 'R';
    
    for (int i = START_LENGTH; i >= 0; i--) {
      body.add(new SnakePoint(i, 0));
    }
  }
  
  List<SnakePoint> getBody () { return body; }
  
  // Only set direction if it is not a direct conflict with the current direction
  void setDirection (char d) {
    if (!opposite(d)) { direction = d; }
  }
  
  private Boolean opposite (char d) {
    return (d == 'U' && direction == 'D') ||
           (d == 'D' && direction == 'U') ||
           (d == 'R' && direction == 'L') ||
           (d == 'L' && direction == 'R');
  }
  
  Boolean moveAuto () { return move(direction); }
  
  // Return true or false based on if move is okay
  Boolean move(char mode) {    
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
