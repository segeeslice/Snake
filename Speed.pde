// Internal speed changing functionality
// Modifies the global variable "speed" to change how fast snake moves

// --- VARIABLES ---
final Integer[] SPEED_VALS = {10, 9, 8, 6, 1};
final String[] SPEED_TEXT = {"Easy", "Medium", "Hard", "Sanic", "AI"};
final HashMap<Integer, String> SPEED_MAP = initSpeedMap();

Iterator speedIter = initSpeedIter();

// --- INTERNAL FUNCTIONS ---
HashMap initSpeedMap () {
  HashMap<Integer, String> map = new HashMap<Integer, String>();
  for (int i = 0; i < SPEED_TEXT.length; i++) {
    map.put(SPEED_VALS[i], SPEED_TEXT[i]);
  }
  return map;
}

// Initialize an iterator to cycle through SPEED_VALS array
Iterator initSpeedIter() {
  return Arrays.asList(SPEED_VALS).iterator();
}

// --- COMMON USE FUNCTIONS ---
// Infinitely cycle through SPEED_VALS
void cycleSpeed () {
  if (!speedIter.hasNext()) { speedIter = initSpeedIter(); }
  speed = (Integer)speedIter.next();
}
