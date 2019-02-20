// Internal speed changing functionality
// Modifies the global variable "speed" to change how fast snake moves

// Here for reference. Needs to be in Globals for high score monitoring
// final String[] SPEED_TEXT = {"Easy", "Medium", "Hard", "Sanic", "AI"};

// --- VARIABLES ---
final Integer[] SPEED_VALS = {10, 9, 8, 6, 2};
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
// Infinitely cycle through SPEED_VALS and monitor difficulty high scores
void cycleSpeed () {
  highScoreMap.replace(speedText, highScore);

  if (!speedIter.hasNext()) { speedIter = initSpeedIter(); }
  speed = (Integer)speedIter.next();
  speedText = SPEED_MAP.get(speed);
  
  highScore = highScoreMap.get(speedText);
}

String getSpeedText () {
  return SPEED_MAP.get(speed); 
}
