import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class snake extends PApplet {



public void setup () {
  // Prelim
  
  stroke(255);
  strokeWeight(2);
  ellipseMode(CENTER);

  // Game
  rectMode(CORNER);
  frameRate(120);

  // Init speed setting functionality
  cycleSpeed();
}

public void draw () {
  background(100);
  scoreboard();
  speedButton.draw();

  // --- VARIABLE UI ---

  if (snakeDied || playing) {
    drawSnake();
    drawFood();
  }

  if (!playing) {
    if (viewBoard) {
      viewBoardExitButton.draw();

    } else {
      playButton.draw();

      if (snakeDied) {
        viewBoardButton.draw();
      }
    }
  }

  // --- GAME ---

  if (playing) {
    moveSnake();
  }
}

public void keyPressed () {
  switch (keyCode) {
    case UP:
      snake.setDirection('U');
      break;

    case DOWN:
      snake.setDirection('D');
      break;

    case LEFT:
      snake.setDirection('L');
      break;

    case RIGHT:
      snake.setDirection('R');
      break;
  }
}

public void mousePressed () {
  // If play button is pressed
  if (!playing && playButton.mouseIsOver()) {
    snake = new Snake();
    newFood();
    score = 0;
    playing = true;
  }

  if (!playing && speedButton.mouseIsOver()) {
    cycleSpeed();
    score = 0;
  }

  if (!playing && snakeDied) {
    if (!viewBoard && viewBoardButton.mouseIsOver()) {
      viewBoard = true;
    } else if (viewBoard && viewBoardExitButton.mouseIsOver()) {
      viewBoard = false;
    }
  }
}

// ---- UI ELEMENTS ----

public void scoreboard () {
  // Box
  fill(70);
  strokeWeight(0);
  rect(0, 0, 500, SCORE_HEIGHT);

  fill(255);
  textSize(23);

  // Score text
  textAlign(RIGHT, CENTER);
  text("Score: " + score.toString(), 490, SCORE_HEIGHT/2);

  // High score text
  textAlign(CENTER, CENTER);
  text("Best: " + highScore.toString(), 250, SCORE_HEIGHT/2);

  strokeWeight(2); // Reset to original
}

public void drawSnake () {
  for (SnakePoint p : snake.getBody()) {
    fill(p.getColor());
    rect(p.getXCoord(), p.getYCoord(), SEG_SIZE, SEG_SIZE);
  }
}

public void drawFood () {
  fill(food.getColor());
  rect(food.getXCoord(), food.getYCoord(), SEG_SIZE, SEG_SIZE);
}

public void moveSnake () {
  // Only move at certain intervals, but keep framerate high
  // to lessen input latency
  if (frameCount % speed == 0) {
    if (speedText == "Neural") {
      playing = NAI.processInput();
    } else if (speedText == "Brute") {
      playing = BAI.processInput();
    } else {
      playing = snake.moveAuto();
    }

    if (snake.eating(food)) {
      newFood();
      snake.addPoints(GROW_AMT);
      score++;
      if (score > highScore) { highScore = score; }
    }

    if (!playing) {
      snakeDied = true;
    }
  }
}

// ---- UTIL FUNCTIONS ----

// TODO: Modify and add view board button
public Boolean mouseOverPlay () {
  float disX = 250 - mouseX;
  float disY = 250 + SCORE_HEIGHT - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < PLAY_BUTTON_DIAM/2) {
    return true;
  } else {
    return false;
  }
}

public Boolean mouseOverSpeed() {
  int w = 100;
  int h = SCORE_HEIGHT/2+10;

  int x1 = 10;
  int y1 = 10;
  int x2 = w + x1;
  int y2 = h + y1;

  return (mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y2);
}
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
final int BOARD_WIDTH = 500;  // Need to modify here and directly in snake.pde if desired
final int BOARD_HEIGHT = 500;

final int PLAY_BUTTON_DIAM = 70;
final int PLAY_BUTTON_WIDTH = 100;
final int PLAY_BUTTON_HEIGHT = 70;
final int VIEW_BOARD_BUTTON_HEIGHT = 30;

final int SCORE_HEIGHT = 50;

final int BOARD_CENTER_X = BOARD_WIDTH / 2;
final int BOARD_CENTER_Y = (BOARD_HEIGHT - SCORE_HEIGHT) / 2 + SCORE_HEIGHT;

final int FOOD_COLOR = color(250, 50, 50);
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
Boolean viewBoard = false;
Integer score = 0;
Integer highScore = 0;
HashMap<String, Integer> highScoreMap = initHighScoreMap();

Integer speed = -1;
String speedText = "";

// --- UTIL FUNCTIONS ---
public SnakePoint randomFood () {
  int x = 0;
  int y = 0;

  do {
    x = PApplet.parseInt(random(25));
    y = PApplet.parseInt(random(25));
  } while (snake.hitBody(x, y));

  return new SnakePoint(x, y, FOOD_COLOR);
}

public void newFood() {
  food = randomFood();
}

public HashMap<String, Integer> initHighScoreMap () {
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  for (String s: SPEED_TEXT) {
    map.put(s, new Integer(0));
  }
  return map;
}

// Get a random elem from a passed list. If the list is of size 0, return the passed default.
public Object randomElem (ArrayList<?> selection, Object def) {
  int randIndex = (int)floor(random(selection.size()));
  return selection.size() > 0 ? selection.get(randIndex) : def;
}

public char rightDir (char d) {
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

public char leftDir (char d) {
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

public Boolean isOpposite (char x, char y) {
  return (x == 'U' && y == 'D') ||
    (x == 'D' && y == 'U') ||
    (x == 'R' && y == 'L') ||
    (x == 'L' && y == 'R');
}

public char getOpposite (char c) {
  for (char dir : DIRECTIONS) {
    if (isOpposite(c, dir)) {
      return dir;
    }
  }

  return '\0';
}

public int[] getNextCoords (int x, int y, char dir) {
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
class Brute {
  static final char PARENT_CHAR = 'P';

  Vector<Character> moves;

  // TODO: remove
  Random random = new Random();

  Brute () {
    moves = new Vector<Character>();
  }

  public Boolean processInput () {
    if (moves.isEmpty()) {
      generatePath();
    }

    Character dir = moves.get(0);
    moves.remove(0);

    return snake.move(dir);
  }

  // Wrappers/default values for the more specific generatePath method
  public Boolean generatePath () {
    return generatePath (food.getX(), food.getY(), snake, false, false);
  }
  public Boolean generatePath (int x, int y) {
    return generatePath (x, y, snake, false, false);
  }
  public Boolean generatePath (int x, int y, Snake startSnake) {
    return generatePath (x, y, startSnake, false, false);
  }
  public Boolean generatePath (int x, int y, Snake startSnake, Boolean rawMode) {
    return generatePath (x, y, startSnake, rawMode, false);
  }

  // Find the shortest path to the food; set `moves` accordingly
  // Assumes moves is empty for efficiency
  // startSnake specifies which snake position it should start from
  // rawMode specifies if it is just looking for the point; does not modify moves
  public Boolean generatePath (int x, int y, Snake startSnake, Boolean rawMode, Boolean tailMode) {
    // Initialize variables for finding neighbors
    Vector<Snake> neighbors;
    BruteQueueItem expanded = null;
    BruteQueueItem successBackup = null;

    // Initialize variables for setting up neighbors
    int turnNumber;
    int distToFood;
    SnakePoint head;

    // Initialize success checker
    Boolean success = false;

    // Generate open queue
    MinHeap<BruteQueueItem> open = new MinHeap<BruteQueueItem>();

    // Generate open and visited hash tables
    // Open has queue and hash table for quicker containment checks
    BruteHashTable openHashTable = new BruteHashTable();
    BruteHashTable visited = new BruteHashTable();

    // Temp items for processing
    BruteQueueItem temp = null;
    BruteQueueItem presentItem = null;

    // Add the current state to the open list
    BruteQueueItem initial = new BruteQueueItem(0, 0, startSnake, PARENT_CHAR);
    open.insert(initial);
    openHashTable.add(initial);

    // Find path to food
    while (!open.isEmpty()) {
      // Expand the next item
      expanded = open.getNext();
      SnakePoint eHead = expanded.snakeState.getHead();
      openHashTable.remove(expanded);

      // Exit and return in raw mode if we have the goal
      // Account for how far we've moved if in tail mode
      if (rawMode && isGoal(expanded, tailMode)) {
        return true;
      }

      // If in normal mode and we found the goal...
      if (!rawMode && isGoal(expanded, false)) {
        // Remember first successful path in case no paths to tail are found
        if (successBackup == null) { successBackup = expanded; }

        // Exit now if a path to the tail exists
        if (hasPathToTail(expanded)) {
          success = true;
          break;
        }
      }

      // Find its neighbors
      neighbors = getNeighbors(expanded.snakeState);

      // Process the neighbors
      for (Snake s : neighbors) {
        temp = new BruteQueueItem(s);

        // Continue early if already visited
        if (visited.contains(temp)) { continue; }

        // Check if open list already contains this item
        // If better one is found, continue. Otherwise, remove from open trackers
        if (openHashTable.contains(temp)) {
          presentItem = openHashTable.get(temp);

          if (presentItem.getPriority() <= temp.getPriority()) {
            continue;
          } else {
            openHashTable.remove(temp);
            open.remove(temp);
          }
        }

        // Apply queue item properties
        temp.move = s.getDirection();
        temp.parent = expanded;
        temp.turnNumber = expanded.turnNumber + 1;

        // TODO: Put into account snake interrupts?
        temp.distToFood = getDistance(s);

        open.insert(temp);
        openHashTable.add(temp);
      }

      // Mark the expanded item visited
      visited.add(expanded);
    }

    // If we reach here in raw mode, it's a failure; return
    if (rawMode) {
      return false;
    }

    // If successful, set up to use the most recent item for path generation
    if (success) {
      temp = expanded;

    // If we do not have success in normal mode, but have a backup, take it
    } else if (successBackup != null) {
      temp = successBackup;

    // If no success paths at all, set up to kill self
    } else {
      moves.add(getOpposite(snake.getDirection()));
      return false;
    }

    // Process path to food (in reverse)
    while (temp.move != PARENT_CHAR) {
      moves.add(temp.move);
      temp = temp.parent;
    }

    // Reverse the list to get proper order
    Collections.reverse(moves);

    // If we reached here, we're in normal mode and successful. Return true
    return true;
  }

  // Returns true if the given queue item is eating
  // Tail mode bool indicates if we should account for growth
  public Boolean isGoal(BruteQueueItem b, Boolean tailMode) {
    return b.snakeState.eating(food) && (!tailMode || b.turnNumber > b.snakeState.getStackedPoints());
  }

  // Returns true if a path to the tail exists
  // Assumes food would be eaten from this position, causing snake to grow
  public Boolean hasPathToTail(BruteQueueItem b) {
    SnakePoint bTail = b.snakeState.getTail();
    Snake grownSnake = b.snakeState.copy();
    grownSnake.addPoints(GROW_AMT);

    return generatePath(bTail.getX(), bTail.getY(), grownSnake, true, true);
  }

  // Return Manhattan distance to food from the given head
  public int getDistance(Snake s) {
    SnakePoint head = s.getHead();

    int headX = head.getX();
    int headY = head.getY();
    int foodX = food.getX();
    int foodY = food.getY();

    int rawDist = Math.abs(headX - foodX) +
                  Math.abs(headY - foodY);

    int xInterrupts = 0;
    int yInterrupts = 0;

    // TODO: Check interrupt
    //if (foodX < headX) {
      //for (int x = headX; x > foodX; x--) {
        //if (s.isBodyAt(x, headY) &&
            //s.distFromTail(x, headY) >= headX - x) {
          //xInterrupts++;
        //}
      //}
    //} else {
      //for (int x = headX; x < foodX; x++) {
        //if (s.isBodyAt(x, headY) &&
            //s.distFromTail(x, headY) >= x - headX) {
          //xInterrupts++;
        //}
      //}
    //}

    //if (foodY < headY) {
      //for (int y = headY; y > foodY; y--) {
        //if (s.isBodyAt(headX, y) &&
            //s.distFromTail(headX, y) >= headY - y) {
          //yInterrupts++;
        //}
      //}
    //} else {
      //for (int y = headY; y < foodY; y++) {
        //if (s.isBodyAt(headX, y) &&
            //s.distFromTail(headX, y) >= y - headY) {
          //yInterrupts++;
        //}
      //}
    //}

    int maxInterrupts = xInterrupts > yInterrupts ? xInterrupts : yInterrupts;

    int result = maxInterrupts > 0 ? maxInterrupts + 1 : 0;

    return rawDist + result;
  }

  // Get neighboring states to the given snake
  public Vector<Snake> getNeighbors (Snake s) {
    int x = s.getHead().getX();
    int y = s.getHead().getY();
    char d = s.getDirection();

    int nextX;
    int nextY;
    int nextCoords[];
    Vector<Snake> neighbors = new Vector<Snake>();

    // Go through all possible directions
    for (int i = 0; i < DIRECTIONS.length; i++) {
      if (!isOpposite(DIRECTIONS[i], d)) {
        // Make a new snake
        Snake newS = s.copy();

        // Attempt to move the snake in the given direction
        // If valid move, it's a good neighbor
        if (newS.move(DIRECTIONS[i]) == true) {
          neighbors.add(newS);
        }
      }
    }

    return neighbors;
  }
}
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
// File to contain the base button class definition

abstract class Button {
  // === BASE COMPONENTS ===

  protected int colorPressed;
  protected int colorNeutral;
  protected int strokeAmount;

  protected String text;
  protected int textColor;
  protected int textSize;

  public Button () {
    colorPressed = color(0);
    colorNeutral = color(0);

    strokeAmount = 0;

    text = "";
    textSize = 0;
  }

  public Button setColorPressed (int c) {
    colorPressed = c;
    return this;
  }
  public Button setColorNeutral (int c) {
    colorNeutral = c;
    return this;
  }

  public Button setStrokeAmount (int s) {
    strokeAmount = s;
    return this;
  }

  public Button setText (String t) {
    text = t;
    return this;
  }
  public Button setTextColor (int c) {
    textColor = c;
    return this;
  }
  public Button setTextSize (int ts) {
    textSize = ts;
    return this;
  }


  // === ABSTRACT COMPONENTS ===

  // Indicate if mouse is over this button or not
  public abstract Boolean mouseIsOver();

  // Draw the button
  public abstract void draw();
}

class RectButton extends Button {
  protected int x1, y1; // Top left rectangle x and y coordinates
  protected int w, h; // Width and height of the rectangle

  public RectButton(int x_in, int y_in, int w_in, int h_in) {
    super();

    x1 = x_in;
    y1 = y_in;
    w = w_in;
    h = h_in;

    strokeAmount = 50;
  }

  // Get bottom right corner x coord
  private int getX2 () {
    return x1 + w;
  }

  // Get bottom right corner y coord
  private int getY2 () {
    return y1 + h;
  }

  private int getCenterX () {
    return x1 + w/2;
  }

  private int getCenterY () {
    return y1 + h/2;
  }

  // === ABSTRACT IMPLEMENTATIONS ===

  public final Boolean mouseIsOver () {
    return (mouseX > x1 && mouseX < getX2() && mouseY > y1 && mouseY < getY2());
  }

  public final void draw () {
    if (!mouseIsOver()) {
      fill(colorNeutral);
    } else {
      fill(colorPressed);
    }

    stroke(strokeAmount);
    rect(x1, y1, w, h);

    fill(0);
    textSize(this.textSize);
    textAlign(CENTER, CENTER);
    text(this.text, getCenterX(), getCenterY()-2);

    // Reset stroke
    stroke(255); // TODO: Investigate removal
  }
}

// NOTE: Since play button refactor, may not need this.
//       However, may be wanted in the future. Keeping here as reminder
//class CircleButton extends Button {
//}
// File to contain the button presets for ease of use

// === CONST VARS ===
// Basic positional things can be changed here
// Further changes must be made within constructors

// Speed button
final int SPEED_X = 8;
final int SPEED_Y = 8;
final int SPEED_WIDTH = 100;
final int SPEED_HEIGHT = SCORE_HEIGHT - (SPEED_Y * 2);

// Play button
final int PLAY_WIDTH = 100;
final int PLAY_HEIGHT = 70;
final int PLAY_X = BOARD_CENTER_X - (PLAY_WIDTH / 2);
final int PLAY_Y = BOARD_CENTER_Y - (PLAY_HEIGHT / 2);

// View board button
final int VIEW_BOARD_WIDTH = PLAY_WIDTH;
final int VIEW_BOARD_HEIGHT = 30;
final int VIEW_BOARD_X = PLAY_X;
final int VIEW_BOARD_Y = PLAY_Y + PLAY_HEIGHT + 5;

// View board exit button
final int VIEW_BOARD_EXIT_WIDTH = 25;
final int VIEW_BOARD_EXIT_HEIGHT = 25;
final int VIEW_BOARD_EXIT_X = BOARD_WIDTH - VIEW_BOARD_EXIT_WIDTH - 10;
final int VIEW_BOARD_EXIT_Y = SCORE_HEIGHT + 10;

// === PRESET CLASSES ===
// NOTE: Done in this way because remaining operations cannot be done in flat file anyway.
//       So it needs to be in its own method, or in a subclass.
//       Subclass seems nicer, so :)

class SpeedButton extends RectButton {
  public SpeedButton () {
    super(SPEED_X, SPEED_Y, SPEED_WIDTH, SPEED_HEIGHT);

    colorNeutral = color(200);
    colorPressed = color(255);
    strokeAmount = 50;

    text = speedText;
    textColor = color(0);
    textSize = 23;
  }
}

class PlayButton extends RectButton {
  public PlayButton () {
    super(PLAY_X, PLAY_Y, PLAY_WIDTH, PLAY_HEIGHT);

    colorNeutral = color(200);
    colorPressed = color(255);
    strokeAmount = 50;

    text = "Play";
    textColor = color(0);
    textSize = 40;
  }
}

class ViewBoardButton extends RectButton {
  public ViewBoardButton () {
    super(VIEW_BOARD_X, VIEW_BOARD_Y, VIEW_BOARD_WIDTH, VIEW_BOARD_HEIGHT);

    colorNeutral = color(200);
    colorPressed = color(255);
    strokeAmount = 50;

    text = "View Board";
    textColor = color(0);
    textSize = 17;
  }
}

class ViewBoardExitButton extends RectButton {
  public ViewBoardExitButton () {
    super(VIEW_BOARD_EXIT_X, VIEW_BOARD_EXIT_Y, VIEW_BOARD_EXIT_WIDTH, VIEW_BOARD_EXIT_HEIGHT);

    colorNeutral = color(200, 175);
    colorPressed = color(255);
    strokeAmount = 50;

    text = "X";
    textColor = color(0, 100);
    textSize = 17;
  }
}

// === PRESET GLOBALS ===

Button speedButton = new SpeedButton();
Button playButton = new PlayButton();
Button viewBoardButton = new ViewBoardButton();
Button viewBoardExitButton = new ViewBoardExitButton();
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
  public T getNext () {
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

  // Remove any value
  public void remove (T val) {
    int index = -1;

    for (int i = 0; i < heap.size(); i++) {
      if (heap.get(i).equals(val)) {
        index = i;
        break;
      }
    }

    if (index > 0) {
      // Swap two values and remove the designated val
      swap(index, heap.size()-1);
      heap.remove(heap.size()-1);

      // Reheap from the found index
      reheapDown(index);
    }
  }

  // Check if heap is empty
  public Boolean isEmpty() {
    return (heap.size() <= 0);
  }

  // Check if heap contains some item
  public Boolean contains(T item) {
    return heap.contains(item);
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

  // Move the first item into its appropriate position
  private void reheapFirst() {
    reheapDown(0);
  }

  // Move the item at the given index to its appropriate position
  private void reheapDown (int startIndex) {
    // Ensure heap has enough items in it
    if (heap.size() <= startIndex) { return; }

    int thisIndex = startIndex;
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
class Neural {  
  Neural () {}
  
  public Boolean processInput () {
    SnakePoint head = snake.getHead();
    
    // --- INPUT DATA ---
    int headX = head.getX();
    int headY = head.getY();
    
    char d = snake.getDirection();
    char dl = leftDir (d);
    char dr = rightDir(d);
    
    // Obstruction distances
    int ld = obsDist(dl, headX, headY);
    int rd = obsDist(dr, headX, headY);
    int sd = obsDist(d,  headX, headY);
    
    // Food coordinates
    int fx = food.getX();
    int fy = food.getY();
    
    // --- HIDDEN LAYER ---
    
    Boolean leftTrapDetect = trapDetect(headX, headY, dl);
    Boolean rightTrapDetect = trapDetect(headX, headY, dr);
    Boolean straightTrapDetect = trapDetect(headX, headY, d);
    
    // Biases
    float lb = .5f;
    float rb = .5f;
    float sb = .7f;
    
    if (!(leftTrapDetect && rightTrapDetect && straightTrapDetect)) {
      lb = leftTrapDetect ? 0 : lb;
      rb = rightTrapDetect ? 0 : rb;
      sb = straightTrapDetect ? 0 : sb;
    }
    
    int flb = foodBias(headX, headY, fx, fy, dl);
    int frb = foodBias(headX, headY, fx, fy, dr);
    int fsb = foodBias(headX, headY, fx, fy, d);

    // Output weights
    float lw = ld * lb * flb;
    float rw = rd * rb * frb;
    float sw = sd * sb * fsb;

    // --- OUTPUT LAYER ---    
    if (lw > rw && lw > sw) { snake.setDirection(dl); return snake.moveAuto(); }
    else if (rw > lw && rw > sw) { snake.setDirection(dr); return snake.moveAuto(); }
    else if (sw > lw && sw > rw) { return snake.moveAuto(); }
    else {
      // Add some extra processing to ensure we do not randomly go right into obstruction
      ArrayList<Character> nonZero = new ArrayList<Character>();
      if (lw != 0) { nonZero.add(dl); }
      if (rw != 0) { nonZero.add(dr); }
      if (sw != 0) { nonZero.add(d); }
      
      snake.setDirection((char)randomElem(nonZero, d));
      return snake.moveAuto(); 
    }
  }
  
  // ---- UTIL FUNCTIONS ----
  // Return distance to nearest obstruction in the passed direction
  private int obsDist (char d, int x, int y) {
    int dist = 0;
    
    switch (d) {
      case 'D':
        for (int i = y+1; i < BOARD_SIZE; i++) {
          if (snake.hitBody(x, i)) { return dist; }
          dist++;
        }
        break;
        
      case 'U':
        for (int i = y-1; i >= 0; i--) {
          if (snake.hitBody(x, i)) { return dist; }
          dist++;
        }
        break;
        
      case 'R':
        for (int i = x+1; i < BOARD_SIZE; i++) {
          if (snake.hitBody(i, y)) { return dist; }
          dist++;
        }
        break;
        
      case 'L':
        for (int i = x-1; i >= 0; i--) {
          if (snake.hitBody(i, y)) { return dist; }
          dist++;
        }
        break;
        
      default:
        println("Something went wrong");
    }
    
    return dist;
  }
  
  // return if the next obstruction is a piece of the snake
  // Takes in x and y coordinates of NEXT head location
  private Boolean hitSnake (int x, int y, char d) {    
    switch (d) {
      case 'D':
        for (int i = y; i < BOARD_SIZE; i++) {
          if (snake.hitBody(x, i)) { return true; }
        }
        break;
        
      case 'U':
        for (int i = y; i >= 0; i--) {
          if (snake.hitBody(x, i)) { return true; }
        }
        break;
        
      case 'R':
        for (int i = x; i < BOARD_SIZE; i++) {
          if (snake.hitBody(i, y)) { return true; }
        }
        break;
        
      case 'L':
        for (int i = x; i >= 0; i--) {
          if (snake.hitBody(i, y)) { return true; }
        }
        break;
        
      default:
        println("Something went wrong");
    }
    
    return false;
  }
  
  private int foodBias (int headX, int headY, int foodX, int foodY, char d) {
    int xDiff = foodX-headX;
    int yDiff = foodY-headY;
    
    switch (d) {
      case 'U':
        if (yDiff < 0) { return yDiff + 25; }
        break;
      case 'D':
        if (yDiff > 0) { return -yDiff + 25; }
        break;
      case 'R':
        if (xDiff > 0) { return -xDiff + 25; }
        break;
      case 'L':
        if (xDiff < 0) { return xDiff + 25; }
        break;
      default:
        println("Something went wrong oh no gee dang");
    }
    
    return 1;
  }

  // Return if we will be trapped 
  public Boolean trapDetect (int headX, int headY, char d) {
    Vector<Character> dirs = new Vector<Character>();
    dirs.add('U');
    dirs.add('D');
    dirs.add('L');
    dirs.add('R');
    
    switch (d) {
      case 'U':
        dirs.remove((Character)'D');
        break;
      case 'D':
        dirs.remove((Character)'U');
        break;
      case 'R':
        dirs.remove((Character)'L');
        break;
      case 'L':
        dirs.remove((Character)'R');
        break;
      default:
        println("Something went wrong oh no gee dang");
    }
    
    
    for (Character dir : dirs) {
      switch (d) {
        case 'U':
          if (!hitSnake(headX, headY-1, dir)) { return false; }
          break;
        case 'D':
          if (!hitSnake(headX, headY+1, dir)) { return false; }
          break;
        case 'R':
          if (!hitSnake(headX+1, headY, dir)) { return false; }
          break;
        case 'L':
          if (!hitSnake(headX-1, headY, dir)) { return false; }
          break;
        default:
          println("Something went wrong oh no gee dang");
      }
    }
    return true;
  }
}
// Simply store coordinates of one segment of snake
// Based on 0-indexed 25x25 grid
class SnakePoint {
  private int x;
  private int y;
  private int c;

  SnakePoint (int x_in, int y_in) {
    x = x_in;
    y = y_in;
    c = color(255);
  }

  SnakePoint (int x_in, int y_in, int c_in) {
    x = x_in;
    y = y_in;
    c = c_in;
  }

  public int getColor () { return c; }
  public void setColor (int c_in) { c = c_in; }

  public int getX () { return x; }
  public int getY () { return y; }
  public void setX (int x_in) { x = x_in; }
  public void setY (int y_in) { y = y_in; }

  // Return the coordinates to be displayed
  // Sends top left coordinate, assuming mode CORNER
  public int getXCoord () { return x*20 + PADDING; }
  public int getYCoord () { return y*20 + PADDING + SCORE_HEIGHT; }

  // Copy this snake point by value
  public SnakePoint copy() {
    return new SnakePoint(x, y, c);
  }
}

class Snake {
  private Vector<SnakePoint> body;
  private char direction;
  private char directionLast;
  private int hash;
  private int stackedPoints;
  private final int MAX_EQ_CHECK = 3;
  private final int HASH_PRIME = 49157;
  private Vector<SnakePoint> lastBody;

  private final int headColor = color(242, 215, 242);

  private final Vector<Integer> colors = generateColors();

  Snake () {
    body = new Vector<SnakePoint> ();
    direction = 'R';
    directionLast = 'R';
    stackedPoints = 0;

    // Init head
    body.add(new SnakePoint(0,0));

    // Init body
    addPoints(START_LENGTH - 1);

    colorize();
    updateHash();
  }

  public List<SnakePoint> getBody () { return body; }
  public SnakePoint getHead () { return body.get(0); }
  public SnakePoint getTail () { return body.lastElement(); }

  public void setDirection (char d) { direction = d; }
  public char getDirection () { return direction; }

  public int getHash () { return hash; }

  public int getStackedPoints () { return stackedPoints; }

  // Generate a color gradient for the snake to use in its colorization
  private Vector<Integer> generateColors() {
    Vector<Integer> returnVect = new Vector<Integer>();

    int baseR = 25;
    int baseG = 142;
    int baseB = 25;

    int incVal = 25;

    // Gradient towards red
    for (int i = 0; i < 10; i++) {
      returnVect.add(color(baseR, baseG, baseB));
      baseR += incVal;
    }

    // Gradient from red
    for (int i = 0; i < 10; i++) {
      returnVect.add(color(baseR, baseG, baseB));
      baseR -= incVal;
    }

    // Gradient towards blue
    for (int i = 0; i < 10; i++) {
      returnVect.add(color(baseR, baseG, baseB));
      baseB += incVal;
    }

    // Gradient from blue
    for (int i = 0; i < 10; i++) {
      returnVect.add(color(baseR, baseG, baseB));
      baseB -= incVal;
    }

    return returnVect;
  }

  public void colorize() {
    // Exit to avoid error
    if (body.size() <= 0) { return; }

    // Set head color
    body.get(0).setColor(headColor);

    int cIndex = 0;

    // Set body colors
    for (int i = 1; i < body.size(); i++) {
      body.get(i).setColor(colors.get(cIndex));

      cIndex += 1;
      if (cIndex >= colors.size()) { cIndex = 0; }
    }
  }

  public void addPoint () {
    // Coordinate is arbitrary since next move allows it to be drawn anyway
    body.add(new SnakePoint(-1, -1));
    stackedPoints++;

    // Colorize all items
    // Could be made more efficient but eh
    colorize();
  }
  public void addPoints (int n) {
    for (int i = 0; i < n; i++) { addPoint(); }
  }

  // Only move in direction if it is not a direct conflict with the past direction
  public Boolean moveAuto () {
    if (!isOpposite(direction, directionLast)) {
      return move(direction);
    } else {
      return move(directionLast);
    }
  }

  // Return true or false based on if move is okay
  // Other interfaces should not use this! Acts as direction gatekeeper
  public Boolean move (char dir) {
    SnakePoint s = body.get(0);
    int lastX = s.getX();
    int lastY = s.getY();
    lastBody = this.copyBody();

    // Set last direction for auto movement matching
    directionLast = dir;

    // Set current direction in case it wasn't set previously
    direction = dir;

    int nextCoords[] = getNextCoords(lastX, lastY, dir);
    s.setX(nextCoords[0]);
    s.setY(nextCoords[1]);

    if (hitWall(s.getX(), s.getY())) {
      // Reset to display where we hit
      body = lastBody;
      body.get(0).setColor(color(0));

      return false;

    } else {
      body.set(0, s);

      // Move remaining items to follow front
      return moveNext(1, lastX, lastY);
    }
  }

  // Recursive function to move all parts of the body
  // Moves all parts even if there is a collision for failure
  private Boolean moveNext (int i, int x, int y) {
    if (i >= body.size()) {
      updateHash();
      stackedPoints = stackedPoints <= 0 ? 0 : stackedPoints - 1;

      return true;

    } else if (hitFront(x, y)) {
      body = lastBody;
      body.get(i-1).setColor(color(0));
      return false;

    } else {
      SnakePoint s = body.get(i);
      int lastX = s.getX();
      int lastY = s.getY();

      s.setX(x);
      s.setY(y);

      body.set(i, s);
      return moveNext(i+1, lastX, lastY);
    }
  }

  // Get a hash based on two points
  private int twoPointHash (int x, int y) {
    // Use Integer class to hash
    Integer xInt = new Integer(x);
    Integer yInt = new Integer(y);

    return((xInt.hashCode() + HASH_PRIME) * HASH_PRIME + yInt.hashCode());
  }

  // Update the hash value based on the current body positions
  private void updateHash () {
    hash = 0;

    // Define looping variables
    int xVal;
    int yVal;

    int maxIndex = body.size() < MAX_EQ_CHECK ? body.size() : MAX_EQ_CHECK;

    for (int i = 0; i < maxIndex; i++) {
        // Use Integer class to hash
        xVal = body.get(i).getX();
        yVal = body.get(i).getY();

        // Update the hash value
        hash = hash * HASH_PRIME + twoPointHash(xVal, yVal);
    }
  }

  // Check if the given x and y of the head will hit the body on movement
  // Excludes last snake point since it will move out of the way
  public Boolean hitBody (int x, int y) {
    SnakePoint p;

    for (int i = 0; i < body.size() - 1; i++) {
      p = body.get(i);
      if (p.getX() == x && p.getY() == y) { return true; }
    }

    return false;
  }

  // Check if the x and y of a body piece interfere with the head of the snake
  // For use in movement checks
  public Boolean hitFront (int x, int y) {
    return x == body.get(0).getX() && y == body.get(0).getY();
  }

  public Boolean eating (SnakePoint food) {
    SnakePoint head = getHead();
    return head.getX() == food.getX() && head.getY() == food.getY();
  }

  @Override
  public boolean equals(Object o) {
    // Return true if the passed object refers to the same spot in memory
    if (o == this) { return true; }

    // Return false if the passed object is not the correct type
    if (!(o instanceof Snake)) { return false; }

    // Cast and compare members
    // Equal snakes if their bodies have same coordinates
    Snake s = (Snake)o;

    // Return true if their hashes are the same
    return hash == s.getHash();
  }

  // Copy the snake body points by value
  public Vector<SnakePoint> copyBody() {
    Vector<SnakePoint> copied = new Vector<SnakePoint>();

    for (int i = 0; i < body.size(); i++) {
      copied.add(body.get(i).copy());
    }

    return copied;
  }

  public void setBody(Vector<SnakePoint> b) { body = b; }

  // Copy this object and return it as a new space in memory
  public Snake copy() {
    Snake newSnake = new Snake();
    newSnake.setDirection(direction);
    newSnake.setBody(copyBody());

    return newSnake;
  }

  // Return true if there's a body point at some given x and y
  public Boolean isBodyAt (int x, int y) {
    for (SnakePoint s : body) {
      if (s.getX() == x && s.getY() == y) {
        return true;
      }
    }

    return false;
  }

  public int distFromTail (int x, int y) {
    SnakePoint s;

    for (int i = body.size()-1; i >= 0; i--) {
      s = body.get(i);

      if (s.getX() == x && s.getY() == y) {
        return body.size() - i - 1;
      }
    }

    return 0;
  }
}
// Internal speed changing functionality
// Modifies the global variable "speed" to change how fast snake moves

// Here for reference. Needs to be in Globals for high score monitoring
// final String[] SPEED_TEXT = {"Easy", "Medium", "Hard", "Sanic", "AI", "Brute"};

// --- VARIABLES ---
final HashMap<String, Integer> SPEED_MAP = initSpeedMap();

Iterator speedIter = initSpeedIter();

// --- INTERNAL FUNCTIONS ---
public HashMap initSpeedMap () {
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  for (int i = 0; i < SPEED_TEXT.length; i++) {
    map.put(SPEED_TEXT[i], SPEED_VALS[i]);
  }
  return map;
}

// Initialize an iterator to cycle through SPEED_VALS array
public Iterator initSpeedIter() {
  return Arrays.asList(SPEED_TEXT).iterator();
}

// --- COMMON USE FUNCTIONS ---
// Infinitely cycle through SPEED_VALS and monitor difficulty high scores
public void cycleSpeed () {
  highScoreMap.replace(speedText, highScore);

  if (!speedIter.hasNext()) { speedIter = initSpeedIter(); }
  speedText = (String)speedIter.next();
  speed = SPEED_MAP.get(speedText);

  highScore = highScoreMap.get(speedText);

  speedButton.setText(speedText);
}
  public void settings() {  size(500, 550); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "snake" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
