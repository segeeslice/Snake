class Neural {  
  Neural () {}
  
  Boolean processInput () {
    SnakePoint head = snake.getHead();
    
    // --- INPUT DATA ---
    int headX = head.getX();
    int headY = head.getY();
    
    char d = snake.getDirection();
    char dl = leftDir (d);
    char dr = rightDir(d);
    
    // Obstruction distances
    int ld = obsDist(dl, headX, headY);
    int rd = obsDist(dr, headX, headY);
    int sd = obsDist(d,  headX, headY);
    
    // Food coordinates
    int fx = food.getX();
    int fy = food.getY();
    
    // --- HIDDEN LAYER ---
    
    // Biases (self-learn here?)
    float lb = .5;
    float rb = .5;
    float sb = .7;
    
    int flb = foodBias(headX, headY, fx, fy, dl);
    int frb = foodBias(headX, headY, fx, fy, dr);
    int fsb = foodBias(headX, headY, fx, fy, d);

    // Output weights
    float lw = ld * lb * flb;
    float rw = rd * rb * frb;
    float sw = sd * sb * fsb;

    // --- OUTPUT LAYER ---    
    if (lw > rw && lw > sw) { snake.setDirection(dl); return snake.moveAuto(); }
    else if (rw > lw && rw > sw) { snake.setDirection(dr); return snake.moveAuto(); }
    else if (sw > lw && sw > rw) { return snake.moveAuto(); }
    else {
      // Add some extra processing to ensure we do not randomly go right into obstruction
      ArrayList<Character> nonZero = new ArrayList<Character>();
      if (lw != 0) { nonZero.add(dl); }
      if (rw != 0) { nonZero.add(dr); }
      if (sw != 0) { nonZero.add(d); }
      
      snake.setDirection(randomDir(nonZero, d));
      return snake.moveAuto(); 
    }
  }
  
  // ---- UTIL FUNCTIONS ----
  private char randomDir (ArrayList<Character> dirs, char def) {
     int randIndex = (int)floor(random(dirs.size()));
     return dirs.size() > 0 ? dirs.get(randIndex) : def;
  }
  
  private char leftDir (char d) {
    switch (d) {
      case 'U':
        return 'L';
      case 'D':
        return 'R';
      case 'R':
        return 'U';
      case 'L':
        return 'D';
      default:
        println("Oopsy whoopsy");
        return d;
    } 
  }
  
  private char rightDir (char d) {
    switch (d) {
      case 'U':
        return 'R';
      case 'D':
        return 'L';
      case 'R':
        return 'D';
      case 'L':
        return 'U';
      default:
        println("Oopsy whoopsy");
        return d;
    } 
  }
  
  // return distance to nearest obstruction in the passed direction
  private int obsDist (char d, int x, int y) {
    int dist = 0;
    
    switch (d) {
      case 'D':
        for (int i = y+1; i < BOARD_SIZE; i++) {
          if (snake.hitBody(x, i)) { return dist; }
          dist++;
        }
        break;
        
      case 'U':
        for (int i = y-1; i >= 0; i--) {
          if (snake.hitBody(x, i)) { return dist; }
          dist++;
        }
        break;
        
      case 'R':
        for (int i = x+1; i < BOARD_SIZE; i++) {
          if (snake.hitBody(i, y)) { return dist; }
          dist++;
        }
        break;
        
      case 'L':
        for (int i = x-1; i >= 0; i--) {
          if (snake.hitBody(i, y)) { return dist; }
          dist++;
        }
        break;
        
      default:
        println("Something went wrong");
    }
    
    return dist;
  }
  
  private int foodBias (int headX, int headY, int foodX, int foodY, char d) {
    int xDiff = foodX-headX;
    int yDiff = foodY-headY;
    
    switch (d) {
      case 'U':
        if (yDiff < 0) { return yDiff + 25; }
        break;
      case 'D':
        if (yDiff > 0) { return -yDiff + 25; }
        break;
      case 'R':
        if (xDiff > 0) { return -xDiff + 25; }
        break;
      case 'L':
        if (xDiff < 0) { return xDiff + 25; }
        break;
      default:
        println("Something went wrong oh no gee dang");
    }
    
    return 1;
  }
}
