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
      generatePath(food.getX(), food.getY(), snake, false);
    }

    Character dir = moves.get(0);
    moves.remove(0);

    return snake.move(dir);
  }

  // Find the shortest path to the food; set `moves` accordingly
  // Assumes moves is empty for efficiency
  // startSnake specifies which snake position it should start from
  // rawMode specifies if it is just looking for the point; does not modify moves
  Boolean generatePath (int x, int y, Snake startSnake, Boolean rawMode) {
    // Initialize variables for finding neighbors
    Vector<Snake> neighbors;
    BruteQueueItem expanded = null;

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
      if (rawMode && eHead.getX() == x && eHead.getY() == y && expanded.turnNumber > GROW_AMT) {
        return true;
      }

      // Break out of loop if in normal mode and have the goal
      // TODO: if we found path to food, remember it and take it upon failure
      if (!rawMode && isGoal(expanded)) {
        success = true;
        break;
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

    // If we do not have a success in normal mode, set up to kill self
    if (!success) {
      moves.add(getOpposite(snake.getDirection()));
      return false;
    }

    // Process path to food (in reverse)
    temp = expanded;
    while (temp.move != PARENT_CHAR) {
      moves.add(temp.move);
      temp = temp.parent;
    }

    // Reverse the list to get proper order
    Collections.reverse(moves);

    // If we reached here, we're in normal mode and successful. Return true
    return true;
  }

  // Returns true if the given queue item is eating and has path to tail
  Boolean isGoal(BruteQueueItem b) {
    Snake bSnake = b.snakeState;
    SnakePoint bTail = bSnake.getTail();

    Boolean eatingFood = b.snakeState.eating(food);

    if (!eatingFood) {
      return false;
    }

    Snake grownSnake = bSnake.copy();
    grownSnake.addPoints(GROW_AMT);

    Boolean pathToTail = generatePath(bTail.getX(), bTail.getY(), grownSnake, true);
    return pathToTail;
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
