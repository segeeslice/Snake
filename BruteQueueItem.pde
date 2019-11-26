// Brute AI queue item
// Allows for generic storing and comparison of snake states

class BruteQueueItem implements Comparable<BruteQueueItem> {
  // --- VARIABLES ---
  public float turnNumber;  // # of turns to get to this point
  public int distToFood;    // Estimated distance to food
  public char move;         // Move required to get to this state

  public Snake snakeState;      // Snake of this state
  public BruteQueueItem parent; // Parent (previous move) of this state

  // --- CONSTRUCTORS ---
  BruteQueueItem() {
    turnNumber = 0;
    distToFood = 0;
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
  }

  // --- PUBLIC USE FUNCTIONS ---

  public int getPriority () {
    return distToFood + (int)turnNumber;
  }

  // --- OBJECT OVERRIDES ---

  @Override // == operator; vector containment
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

  @Override // Comparator override
  public int compareTo(BruteQueueItem item) {
    // Return 0 if it's the same object
    if (item == this) { return 0; }

    // Cast and compare according to specification
    return this.getPriority() - item.getPriority();
  }
}

