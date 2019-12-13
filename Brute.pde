class Brute {
  static final char PARENT_CHAR = 'P';

  Vector<Character> moves;

  // TODO: remove
  Random random = new Random();

  Brute () {
    moves = new Vector<Character>();
  }

  Boolean processInput () {
    if (moves.isEmpty()) {
      generatePath();
    }

    Character dir = moves.get(0);
    moves.remove(0);

    return snake.move(dir);
  }

  // Wrappers/default values for the more specific generatePath method
  Boolean generatePath () {
    return generatePath (food.getX(), food.getY(), snake, false, false);
  }
  Boolean generatePath (int x, int y) {
    return generatePath (x, y, snake, false, false);
  }
  Boolean generatePath (int x, int y, Snake startSnake) {
    return generatePath (x, y, startSnake, false, false);
  }
  Boolean generatePath (int x, int y, Snake startSnake, Boolean rawMode) {
    return generatePath (x, y, startSnake, rawMode, false);
  }

  // Find the shortest path to the food; set `moves` accordingly
  // Assumes moves is empty for efficiency
  // startSnake specifies which snake position it should start from
  // rawMode specifies if it is just looking for the point; does not modify moves
  Boolean generatePath (int x, int y, Snake startSnake, Boolean rawMode, Boolean tailMode) {
    // Initialize variables for finding neighbors
    Vector<Snake> neighbors;
    BruteQueueItem expanded = null;
    BruteQueueItem successBackup = null;

    // Initialize variables for setting up neighbors
    int turnNumber;
    int distToFood;
    SnakePoint head;

    // Initialize success checker
    Boolean success = false;

    // Generate open queue
    MinHeap<BruteQueueItem> open = new MinHeap<BruteQueueItem>();

    // Generate open and visited hash tables
    // Open has queue and hash table for quicker containment checks
    BruteHashTable openHashTable = new BruteHashTable();
    BruteHashTable visited = new BruteHashTable();

    // Temp items for processing
    BruteQueueItem temp = null;
    BruteQueueItem presentItem = null;

    // Add the current state to the open list
    BruteQueueItem initial = new BruteQueueItem(0, 0, startSnake, PARENT_CHAR);
    open.insert(initial);
    openHashTable.add(initial);

    // Find path to food
    while (!open.isEmpty()) {
      // Expand the next item
      expanded = open.getNext();
      SnakePoint eHead = expanded.snakeState.getHead();
      openHashTable.remove(expanded);

      // Exit and return in raw mode if we have the goal
      // Account for how far we've moved if in tail mode
      if (rawMode && isGoal(expanded, tailMode)) {
        return true;
      }

      // If in normal mode and we found the goal...
      if (!rawMode && isGoal(expanded, false)) {
        // Remember first successful path in case no paths to tail are found
        if (successBackup == null) { successBackup = expanded; }

        // Exit now if a path to the tail exists
        if (hasPathToTail(expanded)) {
          success = true;
          break;
        }
      }

      // Find its neighbors
      neighbors = getNeighbors(expanded.snakeState);

      // Process the neighbors
      for (Snake s : neighbors) {
        temp = new BruteQueueItem(s);

        // Continue early if already visited
        if (visited.contains(temp)) { continue; }

        // Check if open list already contains this item
        // If better one is found, continue. Otherwise, remove from open trackers
        if (openHashTable.contains(temp)) {
          presentItem = openHashTable.get(temp);

          if (presentItem.getPriority() <= temp.getPriority()) {
            continue;
          } else {
            openHashTable.remove(temp);
            open.remove(temp);
          }
        }

        // Apply queue item properties
        temp.move = s.getDirection();
        temp.parent = expanded;
        temp.turnNumber = expanded.turnNumber + 1;

        // TODO: Put into account snake interrupts?
        temp.distToFood = getDistance(s);

        open.insert(temp);
        openHashTable.add(temp);
      }

      // Mark the expanded item visited
      visited.add(expanded);
    }

    // If we reach here in raw mode, it's a failure; return
    if (rawMode) {
      return false;
    }

    // If successful, set up to use the most recent item for path generation
    if (success) {
      temp = expanded;

    // If we do not have success in normal mode, but have a backup, take it
    } else if (successBackup != null) {
      temp = successBackup;

    // If no success paths at all, set up to kill self
    } else {
      moves.add(getOpposite(snake.getDirection()));
      return false;
    }

    // Process path to food (in reverse)
    while (temp.move != PARENT_CHAR) {
      moves.add(temp.move);
      temp = temp.parent;
    }

    // Reverse the list to get proper order
    Collections.reverse(moves);

    // If we reached here, we're in normal mode and successful. Return true
    return true;
  }

  // Returns true if the given queue item is eating
  // Tail mode bool indicates if we should account for growth
  Boolean isGoal(BruteQueueItem b, Boolean tailMode) {
    return b.snakeState.eating(food) && (!tailMode || b.turnNumber > GROW_AMT);
  }

  // Returns true if a path to the tail exists
  // Assumes food would be eaten from this position, causing snake to grow
  Boolean hasPathToTail(BruteQueueItem b) {
    SnakePoint bTail = b.snakeState.getTail();
    Snake grownSnake = b.snakeState.copy();
    grownSnake.addPoints(GROW_AMT);

    return generatePath(bTail.getX(), bTail.getY(), grownSnake, true, true);
  }

  // Return Manhattan distance to food from the given head
  int getDistance(Snake s) {
    SnakePoint head = s.getHead();

    int headX = head.getX();
    int headY = head.getY();
    int foodX = food.getX();
    int foodY = food.getY();

    int rawDist = Math.abs(headX - foodX) +
                  Math.abs(headY - foodY);

    int xInterrupts = 0;
    int yInterrupts = 0;

    // TODO: Check interrupt
    //if (foodX < headX) {
      //for (int x = headX; x > foodX; x--) {
        //if (s.isBodyAt(x, headY) &&
            //s.distFromTail(x, headY) >= headX - x) {
          //xInterrupts++;
        //}
      //}
    //} else {
      //for (int x = headX; x < foodX; x++) {
        //if (s.isBodyAt(x, headY) &&
            //s.distFromTail(x, headY) >= x - headX) {
          //xInterrupts++;
        //}
      //}
    //}

    //if (foodY < headY) {
      //for (int y = headY; y > foodY; y--) {
        //if (s.isBodyAt(headX, y) &&
            //s.distFromTail(headX, y) >= headY - y) {
          //yInterrupts++;
        //}
      //}
    //} else {
      //for (int y = headY; y < foodY; y++) {
        //if (s.isBodyAt(headX, y) &&
            //s.distFromTail(headX, y) >= y - headY) {
          //yInterrupts++;
        //}
      //}
    //}

    int maxInterrupts = xInterrupts > yInterrupts ? xInterrupts : yInterrupts;

    int result = maxInterrupts > 0 ? maxInterrupts + 1 : 0;

    return rawDist + result;
  }

  // Get neighboring states to the given snake
  Vector<Snake> getNeighbors (Snake s) {
    int x = s.getHead().getX();
    int y = s.getHead().getY();
    char d = s.getDirection();

    int nextX;
    int nextY;
    int nextCoords[];
    Vector<Snake> neighbors = new Vector<Snake>();

    // Go through all possible directions
    for (int i = 0; i < DIRECTIONS.length; i++) {
      if (!isOpposite(DIRECTIONS[i], d)) {
        // Make a new snake
        Snake newS = s.copy();

        // Attempt to move the snake in the given direction
        // If valid move, it's a good neighbor
        if (newS.move(DIRECTIONS[i]) == true) {
          neighbors.add(newS);
        }
      }
    }

    return neighbors;
  }
}
