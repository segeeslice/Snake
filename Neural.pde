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
    
    // --- HIDDEN LAYER ---
    int ld = obsDist(dl, headX, headY);
    int rd = obsDist(dr, headX, headY);
    int sd = obsDist(d,  headX, headY);

    // --- OUTPUT LAYER ---    
    if (ld > rd && ld > sd) { snake.setDirection(dl); return snake.moveAuto(); }
    else if (rd > ld && rd > sd) { snake.setDirection(dr); return snake.moveAuto(); }
    else if (sd > ld && sd > rd) { return snake.moveAuto(); }
    else {
      // Add some extra processing to ensure we do not randomly go right into obstruction
      ArrayList<Character> nonZero = new ArrayList<Character>();
      if (ld != 0) { nonZero.add(dl); }
      if (rd != 0) { nonZero.add(dr); }
      if (sd != 0) { nonZero.add(d); }
      
      snake.setDirection(randomDir(nonZero)); 
      return snake.moveAuto(); 
    }
  }
  
  // ---- UTIL FUNCTIONS ----
  private char randomDir (ArrayList<Character> dirs) {
     int randIndex = (int)floor(random(dirs.size()));
     return dirs.get(randIndex);
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
}
