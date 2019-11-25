// Simple hash table wrapper for the snake class

public class SnakeHashTable {
  Hashtable<Integer, Snake> table;

  public SnakeHashTable () { table = new Hashtable<Integer, Snake>(); }

  public void add (Snake s) { table.put(s.getHash(), s); }

  public Snake get (int hash) { return table.get(hash); }
  public Snake get (Snake s)  { return table.get(s.getHash()); }

  public void remove (int hash) { table.remove(hash); }
  public void remove (Snake s)  { table.remove(s.getHash()); }

  public Boolean contains (int hash) { return table.get(hash) != null; }
  public Boolean contains (Snake s)  { return table.get(s.getHash()) != null; }
}
