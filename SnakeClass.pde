// Total grid is 500 x 500
// Grid is 25 x 25 with boxes of size 20 (not including padding)
// Unfortunately must hardcode dimensions since size(x,y) cannot take variables
final int PADDING = 1;
final int BOX_SIZE = 20-(2*PADDING);

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
