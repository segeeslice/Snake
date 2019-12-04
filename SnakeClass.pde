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
  private int hash;
  private final int MAX_EQ_CHECK = 4;
  private final int HASH_PRIME = 49157;

  private final color headColor = color(242, 215, 242);

  private final Vector<Integer> colors = generateColors();

  Snake () {
    body = new Vector<SnakePoint> ();
    direction = 'R';
    directionLast = 'R';

    for (int i = START_LENGTH; i >= 0; i--) {
      body.add(new SnakePoint(0, 0));
    }

    colorize();
    updateHash();
  }

  List<SnakePoint> getBody () { return body; }
  SnakePoint getHead () { return body.get(0); }
  SnakePoint getTail () { return body.lastElement(); }

  void setDirection (char d) { direction = d; }
  char getDirection () { return direction; }

  int getHash () { return hash; }

  // Generate a color gradient for the snake to use in its colorization
  private Vector<Integer> generateColors() {
    Vector<Integer> returnVect = new Vector<Integer>();

    int baseR = 25;
    int baseG = 142;
    int baseB = 25;

    int incVal = 25;

    // Gradient towards red
    for (int i = 0; i < 10; i++) {
      returnVect.add(color(baseR, baseG, baseB));
      baseR += incVal;
    }

    // Gradient from red
    for (int i = 0; i < 10; i++) {
      returnVect.add(color(baseR, baseG, baseB));
      baseR -= incVal;
    }

    // Gradient towards blue
    for (int i = 0; i < 10; i++) {
      returnVect.add(color(baseR, baseG, baseB));
      baseB += incVal;
    }

    // Gradient from blue
    for (int i = 0; i < 10; i++) {
      returnVect.add(color(baseR, baseG, baseB));
      baseB -= incVal;
    }

    return returnVect;
  }

  void colorize() {
    // Exit to avoid error
    if (body.size() <= 0) { return; }

    // Set head color
    body.get(0).setColor(headColor);

    int cIndex = 0;

    // Set body colors
    for (int i = 1; i < body.size(); i++) {
      body.get(i).setColor(colors.get(cIndex));

      cIndex += 1;
      if (cIndex >= colors.size()) { cIndex = 0; }
    }
  }

  void addPoint () {
    // Coordinate is arbitrary since next move allows it to be drawn anyway
    body.add(new SnakePoint(-1, -1));

    // Colorize all items
    // Could be made more efficient but eh
    colorize();
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
    if (i >= body.size()) {
      updateHash();
      return true;

    } else if (hitFront(x, y)) {
      return false;

    } else {
      SnakePoint s = body.get(i);
      int lastX = s.getX();
      int lastY = s.getY();

      s.setX(x);
      s.setY(y);

      body.set(i, s);
      return moveNext(i+1, lastX, lastY);
    }
  }

  // Get a hash based on two points
  private int twoPointHash (int x, int y) {
    // Use Integer class to hash
    Integer xInt = new Integer(x);
    Integer yInt = new Integer(y);

    return((xInt.hashCode() + HASH_PRIME) * HASH_PRIME + yInt.hashCode());
  }

  // Update the hash value based on the current body positions
  private void updateHash () {
    hash = 0;

    // Define looping variables
    int xVal;
    int yVal;

    int maxIndex = body.size() < MAX_EQ_CHECK ? body.size() : MAX_EQ_CHECK;

    for (int i = 0; i < maxIndex; i++) {
        // Use Integer class to hash
        xVal = body.get(i).getX();
        yVal = body.get(i).getY();

        // Update the hash value
        hash = hash * HASH_PRIME + twoPointHash(xVal, yVal);
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

    // Return true if their hashes are the same
    return hash == s.getHash();
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
