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
  
  // --- GAME ---
  if (playing) {
    drawSnake();
    drawFood();
    moveSnake();
    speedTextDisplay(255);
    
  } else {
    playButton();
    speedButton();
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
  if (!playing && mouseOverPlay()) {
    snake = new Snake();
    newFood();
    score = 0;
    playing = true;
  }
  
  if (!playing && mouseOverSpeed()) {
    cycleSpeed();
    score = 0;
  }
}

// ---- UI ELEMENTS ----

public void playButton () {
  if (!mouseOverPlay()) {
    fill(200);
  } else {
    fill(255);
  }
  
  stroke(50);
  ellipse(250, 250+SCORE_HEIGHT, PLAY_BUTTON_DIAM, PLAY_BUTTON_DIAM);
  
  fill(0);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Play", 249, 245+SCORE_HEIGHT);
  
  stroke(255); // Reset stroke after
}

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

public void speedButton () {
  if (!mouseOverSpeed()) {
    fill(200);
  } else {
    fill(255);
  }
  
  stroke(50);
  rect(10,10,100,SCORE_HEIGHT/2+10);
  speedTextDisplay(0);
  
  stroke(255); // Reset stroke after
}

public void speedTextDisplay(int c) {
  fill(c);
  textSize(23);
  textAlign(CENTER,CENTER);
  text(speedText, 60, SCORE_HEIGHT/2); 
}

public void drawSnake () {
  fill(snake.getColor());
  for (SnakePoint p : snake.getBody()) {
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
    if (getSpeedText() == "AI") {
      playing = NAI.processInput();
    } else {
      playing = snake.moveAuto();
    }
    
    if (snake.eating(food)) {
      newFood();
      snake.addPoints(3);
      score++;
      if (score > highScore) { highScore = score; }
    }
  } 
}

// ---- UTIL FUNCTIONS ----

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
// Stored here for the sake of keeping publicly used functions and variables in one location
// Would run through static class, but is a bit tricky in Processing

// Total grid is 500 x 500
// Grid is 25 x 25 with boxes of size 20
// Defined more in SnakeClass

// --- CONSTANTS ---
final int PLAY_BUTTON_DIAM = 100;
final int FOOD_COLOR = color(250, 50, 50);
final int BOARD_SIZE = 25;
final int SCORE_HEIGHT = 50;
final String[] SPEED_TEXT = {"Easy", "Medium", "Hard", "Sanic", "AI"};

// Padding around each individual snake pixel
final int PADDING = 2;
// Size of each snake segment
final int SEG_SIZE = 20-(2*PADDING);

// Beginning length of the snake
final int START_LENGTH = 5;

// --- VARIABLES ---
Snake snake = new Snake ();
Neural NAI = new Neural();
SnakePoint food = randomFood();
Boolean playing = false;
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
    
    // Biases (self-learn here?)
    float lb = .5f;
    float rb = .5f;
    float sb = .7f;
    
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
      
      snake.setDirection(randomDir(nonZero, d));
      return snake.moveAuto(); 
    }
  }
  
  // ---- UTIL FUNCTIONS ----
  private char randomDir (ArrayList<Character> dirs, char def) {
     int randIndex = (int)floor(random(dirs.size()));
     return dirs.size() > 0 ? dirs.get(randIndex) : def;
  }
  
  private char leftDir (char d) {
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
  
  private char rightDir (char d) {
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
  
  // return distance to nearest obstruction in the passed direction
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
}

class Snake {
  private Vector<SnakePoint> body;
  private char direction;
  private char directionLast;
  private int c;
  
  Snake () {
    body = new Vector<SnakePoint> ();
    direction = 'R';
    directionLast = 'R';
    c = color(255);
    
    for (int i = START_LENGTH; i >= 0; i--) {
      body.add(new SnakePoint(0, 0, c));
    }
  }
  
  public List<SnakePoint> getBody () { return body; }
  public SnakePoint getHead () { return body.get(0); }
  public int getColor () { return c; } 
  
  public void setDirection (char d) { direction = d; }
  public char getDirection () { return direction; }
  
  public void addPoint () {
    // Coordinate is arbitrary since next move allows it to be drawn anyway
    body.add(new SnakePoint(-1, -1, c)); 
  }
  public void addPoints (int n ) {
    for (int i = 0; i < n; i++) { addPoint(); }
  }
  
  private Boolean opposite (char x, char y) {
    return (x == 'U' && y == 'D') ||
           (x == 'D' && y == 'U') ||
           (x == 'R' && y == 'L') ||
           (x == 'L' && y == 'R');
  }
  
  // Only move in direction if it is not a direct conflict with the past direction
  public Boolean moveAuto () {
    if (!opposite(direction, directionLast)) {
      return move(direction);
    } else {
      return move(directionLast);
    }
  }
  
  // Return true or false based on if move is okay
  public Boolean move (char mode) {    
    SnakePoint s = body.get(0);
    int lastX = s.getX();
    int lastY = s.getY();
    
    directionLast = mode;
    
    // Move front item
    switch (mode) {
      case 'U':
        s.setY(lastY - 1);
        break;
      case 'D':
        s.setY(lastY + 1);
        break;
      case 'R':
        s.setX(lastX + 1);
        break;
      case 'L':
        s.setX(lastX - 1);
        break;
      default:
        println("Oopsy whoopsy");
    }
    
    if (hitWall(s.getX(), s.getY())) {
      return false;
    } else {
      body.set(0, s);
      
      // Move remaining items to follow front
      return moveNext(1, lastX, lastY);
    }
  }
  
  private Boolean moveNext (int i, int x, int y) {
    if (hitFront(x, y) && i < body.size() - 1) {
      return false;
    } else if (i < body.size()) {
      SnakePoint s = body.get(i);
      int lastX = s.getX();
      int lastY = s.getY();
      
      s.setX(x);
      s.setY(y);
      
      body.set(i, s);
      return moveNext(i+1, lastX, lastY);
    } else {
      return true;
    }
  }
  
  // Check if the given x and y will hit a wall
  public Boolean hitWall (int x, int y) {
    return x < 0 || x > (BOARD_SIZE-1) || y < 0 || y > (BOARD_SIZE-1);
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
}
// Internal speed changing functionality
// Modifies the global variable "speed" to change how fast snake moves

// Here for reference. Needs to be in Globals for high score monitoring
// final String[] SPEED_TEXT = {"Easy", "Medium", "Hard", "Sanic", "AI"};

// --- VARIABLES ---
final Integer[] SPEED_VALS = {10, 9, 8, 6, 2};
final HashMap<Integer, String> SPEED_MAP = initSpeedMap();

Iterator speedIter = initSpeedIter();

// --- INTERNAL FUNCTIONS ---
public HashMap initSpeedMap () {
  HashMap<Integer, String> map = new HashMap<Integer, String>();
  for (int i = 0; i < SPEED_TEXT.length; i++) {
    map.put(SPEED_VALS[i], SPEED_TEXT[i]);
  }
  return map;
}

// Initialize an iterator to cycle through SPEED_VALS array
public Iterator initSpeedIter() {
  return Arrays.asList(SPEED_VALS).iterator();
}

// --- COMMON USE FUNCTIONS ---
// Infinitely cycle through SPEED_VALS and monitor difficulty high scores
public void cycleSpeed () {
  highScoreMap.replace(speedText, highScore);

  if (!speedIter.hasNext()) { speedIter = initSpeedIter(); }
  speed = (Integer)speedIter.next();
  speedText = SPEED_MAP.get(speed);
  
  highScore = highScoreMap.get(speedText);
}

public String getSpeedText () {
  return SPEED_MAP.get(speed); 
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
