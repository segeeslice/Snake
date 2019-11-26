// Simple hash table wrapper for the brute queue item / snake classes

public class BruteHashTable {
  Hashtable<Integer, BruteQueueItem> table;

  public BruteHashTable () {
    table = new Hashtable<Integer, BruteQueueItem>();
  }

  public void add (BruteQueueItem b) {
    table.put(b.snakeState.getHash(), b);
  }

  public BruteQueueItem get (int hash) {
    return table.get(hash);
  }
  public BruteQueueItem get (BruteQueueItem b)  {
    return table.get(b.snakeState.getHash());
  }

  public void remove (int hash) {
    table.remove(hash);
  }
  public void remove (BruteQueueItem b)  {
    table.remove(b.snakeState.getHash());
  }

  public Boolean contains (int hash) {
    return table.get(hash) != null;
  }
  public Boolean contains (BruteQueueItem b)  {
    return table.get(b.snakeState.getHash()) != null;
  }
}
