class BruteQueueItem implements Comparable {
  // --- VARIABLES ---
  public int turnNumber;
  public int distToFood;
  
  public int x;
  public int y;
  
  // --- CONSTRUCTORS ---
  BruteQueueItem() {
    turnNumber = 0;
    distToFood = 0;
  }
  
  BruteQueueItem(int t, int d, int x_in, int y_in) {
    turnNumber = t;
    distToFood = d;
    x = x_in;
    y = y_in;
  }
  
  // --- PUBLIC USE FUNCTIONS ---
  public int getPriority () {
    return turnNumber + distToFood;
  }
  
  // --- OBJECT OVERRIDES ---
  @Override
  public boolean equals(Object o) {
    // Return true if the passed object refers to the same spot in memory
    if (o == this) { return true; }
    
    // Return false if the passed object is not the correct type
    if (!(o instanceof BruteQueueItem)) { return false; }
    
    // Cast and compare members
    BruteQueueItem b = (BruteQueueItem)o;
    return b.x == x && b.y == y && b.turnNumber == turnNumber && b.distToFood == distToFood;
  }
  
  int compareTo(Object o) {
    // Return 0 if it's the same object
    if (o == this) { return 0; }
    
    // Return 0 if passed object is incorrect type
    if (!(o instanceof BruteQueueItem)) { return 0; }

    // Cast and compare according to specification
    BruteQueueItem b = (BruteQueueItem)o;
    return this.getPriority() - b.getPriority();
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
  public void addItem(int t, int d, int x_in, int y_in) {
    int index = 0;
    BruteQueueItem item = new BruteQueueItem(t, d, x_in, y_in);
    
    // Exit early if this exact item is already in the queue
    if (queue.contains(item)) { return; }  
    
    // Otherwise, add the new item and sort the vector automatically
    queue.add(item);
    Collections.sort(queue);
  }
  
  // Print all items (for test purposes)
  public void printAll() {
    BruteQueueItem temp;
    for (int i = 0; i < queue.size(); i++) {
      temp = queue.get(i);
      println(temp.turnNumber, temp.distToFood, temp.x, temp.y);
    }
    
    println();
  }
}
