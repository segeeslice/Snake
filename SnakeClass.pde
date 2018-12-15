// Simply store coordinates of one segment of snake
// Based on 0-indexed 25x25 grid
class SnakePoint {
  private int x;
  private int y;
  private color c;
  
  SnakePoint (int x_in, int y_in) {
    x = x_in;
    y = y_in;
    c = color(255);
  }
  
  SnakePoint (int x_in, int y_in, color c_in) {
    x = x_in;
    y = y_in;
    c = c_in;
  }
  
  color getColor () { return c; }
  void setColor (color c_in) { c = c_in; }
  
  int getX () { return x; }
  int getY () { return y; }
  void setX (int x_in) { x = x_in; }
  void setY (int y_in) { y = y_in; }
  
  // Return the coordinates to be displayed
  // Sends top left coordinate, assuming mode CORNER
  int getXCoord () { return x*20 + PADDING; }
  int getYCoord () { return y*20 + PADDING + SCORE_HEIGHT; }
}

class Snake {
  private Vector<SnakePoint> body;
  private char direction;
  private char directionLast;
  private color c;
  
  Snake () {
    body = new Vector<SnakePoint> ();
    direction = 'R';
    directionLast = 'R';
    c = color(255);
    
    for (int i = START_LENGTH; i >= 0; i--) {
      body.add(new SnakePoint(i, 0, c));
    }
  }
  
  List<SnakePoint> getBody () { return body; }
  SnakePoint getHead () { return body.get(0); }
  color getColor () { return c; }
  
  void addPoint () {
    // Coordinate is arbitrary since next move allows it to be drawn anyway
    body.add(new SnakePoint(-1, -1, c)); 
  }
  void addPoints (int n ) {
    for (int i = 0; i < n; i++) { addPoint(); }
  }
  
  // Only set direction if it is not a direct conflict with the current direction
  void setDirection (char d) { direction = d; }
  
  private Boolean opposite (char x, char y) {
    return (x == 'U' && y == 'D') ||
           (x == 'D' && y == 'U') ||
           (x == 'R' && y == 'L') ||
           (x == 'L' && y == 'R');
  }
  
  // Only move in direction if it is not a direct conflict with the past direction
  Boolean moveAuto () {
    if (!opposite(direction, directionLast)) {
      return move(direction);
    } else {
      return move(directionLast);
    }
  }
  
  // Return true or false based on if move is okay
  Boolean move(char mode) {    
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
    return x < 0 || x > (BOARD_SIZE-1) || y < 0 || y > (BOARD_SIZE-1);
  }
  
  private Boolean hitFront (int x, int y) {
    return x == body.get(0).getX() && y == body.get(0).getY();
  }
  
  public Boolean bodyInterfere (int x, int y) {
    for (SnakePoint p : body) {
      if (p.getX() == x && p.getY() == y) { return true; }
    }
    
    return false;
  }
  
  public Boolean eating (SnakePoint food) {
    SnakePoint head = getHead();
    return head.getX() == food.getX() && head.getY() == food.getY();
  }
}
