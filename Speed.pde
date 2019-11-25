// Internal speed changing functionality
// Modifies the global variable "speed" to change how fast snake moves

// Here for reference. Needs to be in Globals for high score monitoring
// final String[] SPEED_TEXT = {"Easy", "Medium", "Hard", "Sanic", "AI", "Brute"};

// --- VARIABLES ---
final HashMap<String, Integer> SPEED_MAP = initSpeedMap();

Iterator speedIter = initSpeedIter();

// --- INTERNAL FUNCTIONS ---
HashMap initSpeedMap () {
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  for (int i = 0; i < SPEED_TEXT.length; i++) {
    map.put(SPEED_TEXT[i], SPEED_VALS[i]);
  }
  return map;
}

// Initialize an iterator to cycle through SPEED_VALS array
Iterator initSpeedIter() {
  return Arrays.asList(SPEED_TEXT).iterator();
}

// --- COMMON USE FUNCTIONS ---
// Infinitely cycle through SPEED_VALS and monitor difficulty high scores
void cycleSpeed () {
  highScoreMap.replace(speedText, highScore);

  if (!speedIter.hasNext()) { speedIter = initSpeedIter(); }
  speedText = (String)speedIter.next();
  speed = SPEED_MAP.get(speedText);

  highScore = highScoreMap.get(speedText);
}
