// Generic min heap for efficient sorted queue usage

class MinHeap <T extends Comparable<T>> {
  // === VARIABLES ===

  final Vector<T> heap = new Vector<T>();

  // === PUBLIC INTERFACE ===

  // Insert item into the list
  public void insert(T item) {
    heap.add(item);
    reheapLast();
  }

  // Get the next (minimum) value
  public T getNext() {
    // Ensure heap has value in it
    if (heap.size() == 0) { return null; }


    // Get min val
    T retVal = heap.get(0);

    // Put last val into first spot and remove min val
    swap(0, heap.size()-1);
    heap.remove(heap.size()-1);

    // Reheap from the first
    reheapFirst();

    return retVal;
  }

  // Check if heap is empty
  public Boolean isEmpty() {
    return (heap.size() <= 0);
  }

  // Check if heap contains some item
  public Boolean contains(T item) {
    return heap.contains(item);
  }

  public T get(T item) {
    for (T t: heap) {
      if (t.equals(item)) {
        return t;
      }
    }

    return null;
  }

  // Print all items in heap (for potential debugging purposes)
  public void printAll() {
    for (T item : heap) {
      println(item);
    }

    println();
  }

  // === PARENT/CHILD METHODS ===

  private int getParentIndex(int index) {
    return (int)(index / 2);
  }

  private int getLeftChildIndex(int index) {
    return 2*index;
  }

  private int getRightChildIndex(int index) {
    return 2*index + 1;
  }

  // === OTHER UTIL METHODS ===

  // Swap two given indexes on the heap in place
  private void swap(int ind1, int ind2) {
    if (ind1 >= heap.size() || ind2 >= heap.size()) {
      println("WARNING: Illegal swap");
      return;
    }

    T temp = heap.get(ind1);
    heap.set(ind1, heap.get(ind2));
    heap.set(ind2, temp);
  }

  // Set the last item to the correct position
  private void reheapLast() {
    int thisIndex = heap.size() - 1;
    int parentIndex = getParentIndex(thisIndex);

    T thisItem = heap.get(thisIndex);
    T parentItem = heap.get(parentIndex);

    // While the parent is less than this item...
    while (thisIndex != 0 && thisItem.compareTo(parentItem) < 0) {
      // Swap the items
      swap(thisIndex, parentIndex);

      // Get new indexes/items
      thisIndex = parentIndex;
      parentIndex = getParentIndex(thisIndex);

      thisItem = heap.get(thisIndex);
      parentItem = heap.get(parentIndex);
    }
  }

  // Set the first item into the correct position
  private void reheapFirst() {
    // Ensure heap has items in it
    if (heap.size() == 0) { return; }

    int thisIndex = 0;
    int leftIndex = getLeftChildIndex(thisIndex);
    int rightIndex = getRightChildIndex(thisIndex);

    T thisItem = heap.get(thisIndex);
    T leftItem = leftIndex < heap.size() ? heap.get(leftIndex) : null;
    T rightItem = rightIndex < heap.size() ? heap.get(rightIndex) : null;

    int smallestIndex;

    // While one of the children is greater than this item...
    while (thisIndex < heap.size() &&
           (leftItem != null && thisItem.compareTo(leftItem) > 0 ||
           rightItem != null && thisItem.compareTo(rightItem) > 0)) {

      // NOTE: If left item is null, it should never enter here
      // Find which of the children is the smallest
      if (rightItem == null) {
        smallestIndex = leftIndex;
      } else {
        smallestIndex = leftItem.compareTo(rightItem) < 0 ? leftIndex : rightIndex;
      }

      // Swap the items
      swap(thisIndex, smallestIndex);

      // Get new indexes/items
      thisIndex = smallestIndex;
      leftIndex = getLeftChildIndex(thisIndex);
      rightIndex = getRightChildIndex(thisIndex);

      leftItem = leftIndex < heap.size() ? heap.get(leftIndex) : null;
      rightItem = rightIndex < heap.size() ? heap.get(rightIndex) : null;
    }
  }
}
