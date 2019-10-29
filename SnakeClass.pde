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

  public color getColor () { return c; }
  public void setColor (color c_in) { c = c_in; }

  public int getX () { return x; }
  public int getY () { return y; }
  public void setX (int x_in) { x = x_in; }
  public void setY (int y_in) { y = y_in; }

  // Return the coordinates to be displayed
  // Sends top left coordinate, assuming mode CORNER
  int getXCoord () { return x*20 + PADDING; }
  int getYCoord () { return y*20 + PADDING + SCORE_HEIGHT; }

  // Copy this snake point by value
  public SnakePoint copy() {
    return new SnakePoint(x, y, c);
  }
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
      body.add(new SnakePoint(0, 0, c));
    }
  }

  List<SnakePoint> getBody () { return body; }
  color getColor () { return c; }
  void setColor (color c_in) { c = c_in; }
  SnakePoint getHead () { return body.get(0); }

  void setDirection (char d) { direction = d; }
  char getDirection () { return direction; }

  void addPoint () {
    // Coordinate is arbitrary since next move allows it to be drawn anyway
    body.add(new SnakePoint(-1, -1, c));
  }
  void addPoints (int n) {
    for (int i = 0; i < n; i++) { addPoint(); }
  }

  // Only move in direction if it is not a direct conflict with the past direction
  Boolean moveAuto () {
    if (!isOpposite(direction, directionLast)) {
      return move(direction);
    } else {
      return move(directionLast);
    }
  }

  // Return true or false based on if move is okay
  // Other interfaces should not use this! Acts as direction gatekeeper
  Boolean move (char dir) {
    SnakePoint s = body.get(0);
    int lastX = s.getX();
    int lastY = s.getY();

    // Set last direction for auto movement matching
    directionLast = dir;

    // Set current direction in case it wasn't set previously
    direction = dir;

    int nextCoords[] = getNextCoords(lastX, lastY, dir);
    s.setX(nextCoords[0]);
    s.setY(nextCoords[1]);

    if (hitWall(s.getX(), s.getY())) {
      return false;
    } else {
      body.set(0, s);

      // Move remaining items to follow front
      return moveNext(1, lastX, lastY);
    }
  }

  // Recursive function to move all parts of the body
  private Boolean moveNext (int i, int x, int y) {
    if (hitFront(x, y) && i < body.size() - 1) {
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

  // Check if the given x and y of the head will hit the body on movement
  // Excludes last snake point since it will move out of the way
  public Boolean hitBody (int x, int y) {
    SnakePoint p;

    for (int i = 0; i < body.size() - 1; i++) {
      p = body.get(i);
      if (p.getX() == x && p.getY() == y) { return true; }
    }

    return false;
  }

  // Check if the x and y of a body piece interfere with the head of the snake
  // For use in movement checks
  public Boolean hitFront (int x, int y) {
    return x == body.get(0).getX() && y == body.get(0).getY();
  }

  public Boolean eating (SnakePoint food) {
    SnakePoint head = getHead();
    return head.getX() == food.getX() && head.getY() == food.getY();
  }

  @Override
  public boolean equals(Object o) {
    // Return true if the passed object refers to the same spot in memory
    if (o == this) { return true; }

    // Return false if the passed object is not the correct type
    if (!(o instanceof Snake)) { return false; }

    // Cast and compare members
    // Equal snakes if their bodies have same coordinates
    Snake s = (Snake)o;

    // This could be useful in quicker neighbor checking?
    SnakePoint thisHead = getHead();
    SnakePoint otherHead = s.getHead();
    return thisHead.getX() == otherHead.getX() &&
           thisHead.getY() == otherHead.getY() &&
           getDirection() == s.getDirection();

    //if (getDirection() != s.getDirection()) {
       //return false;
    //}

    //for (int i = 0; i < body.size(); i++) {
      //if (s.body.get(i).x != body.get(i).x ||
          //s.body.get(i).y != body.get(i).y) {
        //return false;
      //}
    //}

    //return true;
  }

  // Copy the snake body points by value
  public Vector<SnakePoint> copyBody() {
    Vector<SnakePoint> copied = new Vector<SnakePoint>();

    for (int i = 0; i < body.size(); i++) {
      copied.add(body.get(i).copy());
    }

    return copied;
  }

  public void setBody(Vector<SnakePoint> b) { body = b; }

  // Copy this object and return it as a new space in memory
  public Snake copy() {
    Snake newSnake = new Snake();
    newSnake.setDirection(direction);
    newSnake.setColor(c);

    newSnake.setBody(copyBody());

    return newSnake;
  }

  // Return true if there's a body point at some given x and y
  public Boolean isBodyAt (int x, int y) {
    for (SnakePoint s : body) {
      if (s.getX() == x && s.getY() == y) {
        return true;
      }
    }

    return false;
  }

  public int distFromTail (int x, int y) {
    SnakePoint s;

    for (int i = body.size()-1; i >= 0; i--) {
      s = body.get(i);

      if (s.getX() == x && s.getY() == y) {
        return body.size() - i - 1;
      }
    }

    return 0;
  }
}
