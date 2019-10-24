class Brute {
  static final char PARENT_CHAR = 'P';

  Vector<Character> moves;

  Brute () {
    moves = new Vector<Character>();
  }

  Boolean processInput () {
    if (moves.isEmpty()) {
      generatePath();
    }

    snake.setDirection(moves.elementAt(0));
    moves.remove(0);

    return snake.moveAuto();
  }

  // Find the shortest path to the food; set `moves` accordingly
  // Assumes moves is empty for efficiency
  void generatePath() {
    // Initialize variable for finding neighbors
    Vector<BruteQueueItem> neighbors;
    BruteQueueItem expanded;

    // Generate open and visited lists
    BruteQueue open = new BruteQueue();
    HashSet<BruteQueueItem> visited = new HashSet<BruteQueueItem>();

    // Add the current state to the visited
    open.addItem(0, 0, snake, PARENT_CHAR);

    while (!open.isEmpty()) {
      // Expand the next item
      expanded = open.dequeue();

      // Exit if we have the goal
      // TODO: uncomment upon completion
      //if (true || isGoal(expanded)) {
        //break;
      //}

      // Find its neighbors
      neighbors = getNeighbors(expanded);

      // For now, just print the neighbors' debug info
      // TODO

      // For now, exit in any case
      break;

      //for (int i = 0; i < neighbors.size(); i++) {
        //if (!visited.contains(neighbors[i])) {
          //// Set up neighbor item
          //open.add(neighbors[i])
        //}
      //}
    }
  }

  // Returns true if the given queue item is at the goal state (eating)
  Boolean isGoal(BruteQueueItem b) {
    return b.snakeState.eating(food);
  }

  // Get neighbors
  // TODO: DO THIS NEXT
  Vector<BruteQueueItem> getNeighbors (BruteQueueItem item) {
    return new Vector<BruteQueueItem>();
  }
}
