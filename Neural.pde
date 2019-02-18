class Neural {  
  Neural () {}
  
  Boolean processInput () {
    SnakePoint head = snake.getHead();
    
    // --- INPUT DATA ---
    int headX = head.getX();
    int headY = head.getY();
    char d = snake.getDirection();
    
    // Quick reference processing
    char dl = leftDir (d);
    char dr = rightDir(d);
    
    int lx = leftX    (d, headX);
    int rx = rightX   (d, headX);
    int sx = straightX(d, headX);
    
    int ly = leftY    (d, headY);
    int ry = rightY   (d, headY);
    int sy = straightY(d, headY);
    
    // --- HIDDEN LAYER ---
    Boolean leftCollide =     snake.hitWall(lx, ly) || snake.hitBody(lx, ly);
    Boolean rightCollide =    snake.hitWall(rx, ry) || snake.hitBody(rx, ry);
    Boolean straightCollide = snake.hitWall(sx, sy) || snake.hitBody(sx, sy);
    
    // --- OUTPUT LAYER ---
    if (!straightCollide)   { return snake.moveAuto(); }
    else if (!leftCollide)  { snake.setDirection(dl); return snake.moveAuto(); }
    else if (!rightCollide) { snake.setDirection(dr); return snake.moveAuto(); }
    else { snake.setDirection(randomDir(d, dl, dr)); return snake.moveAuto(); }
  }
  
  // ---- UTIL FUNCTIONS ----
  private char randomDir (char d1, char d2, char d3) {
     float val = random(3);
     
     if (val < 1)      { return d1; }
     else if (val < 2) { return d2; }
     else              { return d3; }
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
  
  private int leftX (char d, int x) {
    switch (d) {
      case 'U':
        return x-1;
      case 'D':
        return x+1;
      default:
        return x;
    }
  }
  
  private int rightX (char d, int x) {
    switch (d) {
      case 'U':
        return x+1;
      case 'D':
        return x-1;
      default:
        return x;
    }
  }
  
  private int straightX (char d, int x) {
    switch (d) {
      case 'R':
        return x+1;
      case 'L':
        return x-1;
      default:
        return x;
    }
  }
  
  private int leftY (char d, int y) {
   switch (d) {
    case 'R':
      return y-1;
    case 'L':
      return y+1;
    default:
      return y;
   }
  }
  
  private int rightY (char d, int y) {
    switch (d) {
      case 'R':
        return y+1;
      case 'L':
        return y-1;
      default:
        return y;
    }
  }
  
  private int straightY (char d, int y) {
    switch (d) {
      case 'U':
        return y+1;
      case 'D':
        return y-1;
      default:
        return y;
    }
  }
}
