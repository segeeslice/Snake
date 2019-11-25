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

  // Find the shortest path to the food; set `moves` accordingly
  // Assumes moves is empty for efficiency
  void generatePath() {
    // Initialize variables for finding neighbors
    Vector<Snake> neighbors;
    BruteQueueItem expanded = null;

    // Initialize variables for setting up neighbors
    int turnNumber;
    int distToFood;
    SnakePoint head;

    // Generate open queue
    MinHeap<BruteQueueItem> open = new MinHeap<BruteQueueItem>();

    // Generate open and visited hash tables
    // Open has queue and hash table for quicker containment checks
    SnakeHashTable openHashTable = new SnakeHashTable();
    SnakeHashTable visited = new SnakeHashTable();

    // Temp item for processing
    BruteQueueItem temp = null;

    // Add the current state to the open list
    open.insert(new BruteQueueItem(0, 0, snake, PARENT_CHAR));
    openHashTable.add(snake);

    // Find path to food
    while (!open.isEmpty()) {
      // Expand the next item
      expanded = open.getNext();

      // Exit if we have the goal
      if (isGoal(expanded)) {
        break;
      }

      // Find its neighbors
      neighbors = getNeighbors(expanded.snakeState);

      // Process the neighbors
      for (Snake s : neighbors) {
        temp = new BruteQueueItem(s);

        // Exit early if already visited
        // TODO: Remove open check and check if new item better
        if (visited.contains(temp.snakeState) ||
            openHashTable.contains(temp.snakeState)) { continue; }

        // Apply queue item properties
        temp.move = s.getDirection();
        temp.parent = expanded;
        temp.turnNumber = expanded.turnNumber + 1;

        // TODO: Put into account snake interrupts?
        temp.distToFood = getDistance(s);

        // TODO: Compare if item already in open list
        open.insert(temp);
        openHashTable.add(temp.snakeState);
      }

      // Mark the expanded item visited
      visited.add(expanded.snakeState);
      openHashTable.remove(expanded.snakeState);
    }

    // Process path to food (in reverse)
    temp = expanded;
    while (temp.move != PARENT_CHAR) {
      moves.add(temp.move);
      temp = temp.parent;
    }

    // Reverse the list to get proper order
    Collections.reverse(moves);

    // If no path to goal, just go straight
    // TODO: Just go opposite direction and kill self
    if (moves.isEmpty()) {
      moves.add(snake.getDirection());
    }
  }

  // Returns true if the given queue item is at the goal state (eating)
  Boolean isGoal(BruteQueueItem b) {
    return b.snakeState.eating(food);
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
