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
    // Initialize variable for finding neighbors
    Vector<Snake> neighbors;
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
      neighbors = getNeighbors(expanded.snakeState);

      // For now, just get a random val and go that way
      moves.add(neighbors.get(random.nextInt(neighbors.size())).getDirection());

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
