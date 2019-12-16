/*
 * Globals are stored in this class to keep in one location
 * Would run through static class, but is a bit tricky in Processing
 *
 * File name appended with A_ because Processing files are included in alphabetical order
 * As such, globals here should have no dependencies on other custom classes
 *
 * Total grid is 500 x 500
 * Grid is 25 x 25 with boxes of size 20
 * Defined more in SnakeClass
 */

// --- CONSTANTS ---
final int PLAY_BUTTON_DIAM = 70;
final int PLAY_BUTTON_WIDTH = 100;
final int PLAY_BUTTON_HEIGHT = 70;
final int VIEW_BOARD_BUTTON_HEIGHT = 30;

final int SCORE_HEIGHT = 50;

final int BOARD_CENTER_X = 250;
final int BOARD_CENTER_Y = 250 + SCORE_HEIGHT;

final color FOOD_COLOR = color(250, 50, 50);
final int BOARD_SIZE = 25;
final String[] SPEED_TEXT = {"Easy", "Medium", "Hard", "Sanic", "Neural", "Brute"};
final Integer[] SPEED_VALS = {10, 9, 8, 6, 5, 5};
final char[] DIRECTIONS = {'U', 'D', 'L', 'R'};

// Padding around each individual snake pixel
final int PADDING = 2;
// Size of each snake segment
final int SEG_SIZE = 20-(2*PADDING);

// Beginning length of the snake
final int START_LENGTH = 5;
// Amount the snake grows upon eating food
final int GROW_AMT = 3;

// --- VARIABLES ---
Snake snake = new Snake ();
Neural NAI = new Neural();
Brute BAI = new Brute();
SnakePoint food = randomFood();
Boolean playing = false;
Boolean snakeDied = false;
Integer score = 0;
Integer highScore = 0;
HashMap<String, Integer> highScoreMap = initHighScoreMap();

Integer speed = -1;
String speedText = "";

// --- UTIL FUNCTIONS ---
SnakePoint randomFood () {
  int x = 0;
  int y = 0;

  do {
    x = int(random(25));
    y = int(random(25));
  } while (snake.hitBody(x, y));

  return new SnakePoint(x, y, FOOD_COLOR);
}

void newFood() {
  food = randomFood();
}

HashMap<String, Integer> initHighScoreMap () {
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  for (String s: SPEED_TEXT) {
    map.put(s, new Integer(0));
  }
  return map;
}

// Get a random elem from a passed list. If the list is of size 0, return the passed default.
Object randomElem (ArrayList<?> selection, Object def) {
  int randIndex = (int)floor(random(selection.size()));
  return selection.size() > 0 ? selection.get(randIndex) : def;
}

char rightDir (char d) {
  switch (d) {
    case 'U':
      return 'R';
    case 'D':
      return 'L';
    case 'R':
      return 'D';
    case 'L':
      return 'U';
    default:
      println("Oopsy whoopsy");
      return d;
  }
}

char leftDir (char d) {
  switch (d) {
    case 'U':
      return 'L';
    case 'D':
      return 'R';
    case 'R':
      return 'U';
    case 'L':
      return 'D';
    default:
      println("Oopsy whoopsy");
      return d;
  }
}

Boolean isOpposite (char x, char y) {
  return (x == 'U' && y == 'D') ||
    (x == 'D' && y == 'U') ||
    (x == 'R' && y == 'L') ||
    (x == 'L' && y == 'R');
}

char getOpposite (char c) {
  for (char dir : DIRECTIONS) {
    if (isOpposite(c, dir)) {
      return dir;
    }
  }

  return '\0';
}

int[] getNextCoords (int x, int y, char dir) {
    switch (dir) {
      case 'U':
        y -= 1;
        break;
      case 'D':
        y += 1;
        break;
      case 'R':
        x += 1;
        break;
      case 'L':
        x -= 1;
        break;
      default:
        println("Oopsy whoopsy");
    }

    return new int[] {x, y};
}

// Check if the given x and y will hit a wall
public Boolean hitWall (int x, int y) {
  return x < 0 || x > (BOARD_SIZE-1) || y < 0 || y > (BOARD_SIZE-1);
}

