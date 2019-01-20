// Stored here for the sake of keeping publicly used functions and variables in one location
// Would run through static class, but is a bit tricky in Processing

// Total grid is 500 x 500
// Grid is 25 x 25 with boxes of size 20
// Defined more in SnakeClass

// --- CONSTANTS ---
final int PLAY_BUTTON_DIAM = 100;
final color FOOD_COLOR = color(250, 50, 50);
final int BOARD_SIZE = 25;
final int SCORE_HEIGHT = 50;

// Padding around each individual snake pixel
final int PADDING = 2;
// Size of each snake segment
final int SEG_SIZE = 20-(2*PADDING);

// Beginning length of the snake
final int START_LENGTH = 5;

// Speed map keys and values
// These must be the same length for map
final Integer[] SPEED_VALS = {10, 9, 8, 6, 1};
final String[] SPEED_TEXT = {"Easy", "Medium", "Hard", "Sanic", "AI"};
final HashMap<Integer, String> SPEED_MAP = initSpeedMap();

// --- VARIABLES ---
Snake snake = new Snake ();
SnakePoint food = randomFood();
Boolean playing = false;
Integer score = 0;
Integer speed = -1;

// --- UTIL FUNCTIONS ---
SnakePoint randomFood () {
  int x = 0;
  int y = 0;
  
  do {
    x = int(random(25));
    y = int(random(25));
  } while (snake.bodyInterfere(x, y));
  
  return new SnakePoint(x, y, FOOD_COLOR);
}

void newFood() { 
  food = randomFood();
}

HashMap initSpeedMap () {
  HashMap<Integer, String> map = new HashMap<Integer, String>();
  for (int i = 0; i < SPEED_TEXT.length; i++) {
    map.put(SPEED_VALS[i], SPEED_TEXT[i]);
  }
  return map;
}

// Initialize an iterator to cycle through SPEED_VALS array
Iterator initSpeedIter() { return Arrays.asList(SPEED_VALS).iterator(); }
Iterator speedIter = initSpeedIter();

// Infinitely cycle through SPEED_VALS
void cycleSpeed () {
  if (!speedIter.hasNext()) { speedIter = initSpeedIter(); }
  speed = (Integer)speedIter.next();
}
