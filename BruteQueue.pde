int BRUTE_ID_TRACKER = 1;

class BruteQueueItem implements Comparable {
  // --- VARIABLES ---
  public int turnNumber;
  public int distToFood;

  public Snake snakeState;

  public char move;

  public BruteQueueItem parent;

  int id;
  int pid;

  // --- CONSTRUCTORS ---
  BruteQueueItem() {
    turnNumber = 0;
    distToFood = 0;

    id = 0;
    pid = -1;
  }

  BruteQueueItem(Snake s) {
    this();
    snakeState = s;
  }

  BruteQueueItem(int t, int d, Snake s, char m) {
    turnNumber = t;
    distToFood = d;
    snakeState = s;
    move = m;

    id = 0;
    pid = -1;
  }

  // --- PUBLIC USE FUNCTIONS ---
  public int getPriority () {
    return distToFood;
  }

  public void assignId () {
    id = BRUTE_ID_TRACKER;
    BRUTE_ID_TRACKER++;
  }

  // --- OBJECT OVERRIDES ---
  @Override
  public boolean equals(Object o) {
    // Return true if the passed object refers to the same spot in memory
    if (o == this) { return true; }

    // Return false if the passed object is not the correct type
    if (!(o instanceof BruteQueueItem)) { return false; }

    // Cast and compare members
    // Two queue items considered equal if same snake positions
    BruteQueueItem b = (BruteQueueItem)o;
    return b.snakeState.equals(snakeState);
  }

  @Override
  public int compareTo(Object o) {
    // Return 0 if it's the same object
    if (o == this) { return 0; }

    // Return 0 if passed object is incorrect type
    if (!(o instanceof BruteQueueItem)) { return 0; }

    // Cast and compare according to specification
    BruteQueueItem b = (BruteQueueItem)o;
    return this.getPriority() - b.getPriority();
  }


  // Return true if this item less than passed item
  public Boolean lessThan(BruteQueueItem b) {
    return this.getPriority() < b.getPriority();
  }

  // Return true if this item is greater than passed item
  public Boolean greaterThan(BruteQueueItem b) {
    return this.getPriority() > b.getPriority();
  }
}

// Priority queue weighted by turn number and the distance to the food together
class BruteQueue {
  // --- VARIABLES ---
  Vector<BruteQueueItem> queue;

  // --- FUNCTIONS ---
  BruteQueue() {
    queue = new Vector<BruteQueueItem>();
  }

  // Add an item to the queue in its appropriate position
  // turn number, distance to food, snake, move
  public void addItem(int t, int d, Snake s, char m) {
    BruteQueueItem item = new BruteQueueItem(t, d, s, m);
    addItem(item);
  }

  public void addItem (BruteQueueItem item) {
    // Assume if item is added, we know it is not already in queue
    // if (queue.contains(item)) { return; }

    // Otherwise, find a new location for the item and add
    Boolean added = false;
    for (int i = 0; i < queue.size(); i++) {
      if (item.lessThan(queue.get(i))) {
        queue.add(i, item);
        added = true;
        break;
      }
    }

    if (!added) { queue.add(item); }

    queue.add(item);
  }

  // Check if queue contains an item
  public Boolean contains(BruteQueueItem item) {
    return queue.contains(item);
  }

  // Dequeue the front of the list and return it
  public BruteQueueItem dequeue() {
    BruteQueueItem ret = queue.get(0);
    queue.remove(0);
    return ret;
  }

  // Return true if no items in queue
  public Boolean isEmpty() {
    return queue.isEmpty();
  }

  // Print all items (for test purposes)
  public void printAll() {
    BruteQueueItem temp;
    for (int i = 0; i < queue.size(); i++) {
      temp = queue.get(i);
      println(temp.turnNumber, temp.distToFood);
    }

    println();
  }
}
