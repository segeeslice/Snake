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
    playing = snake.moveAuto();
    
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
  } while (snake.bodyInterfere(x, y));
  
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
      body.add(new SnakePoint(i, 0, c));
    }
  }
  
  public List<SnakePoint> getBody () { return body; }
  public SnakePoint getHead () { return body.get(0); }
  public int getColor () { return c; }
  
  public void addPoint () {
    // Coordinate is arbitrary since next move allows it to be drawn anyway
    body.add(new SnakePoint(-1, -1, c)); 
  }
  public void addPoints (int n ) {
    for (int i = 0; i < n; i++) { addPoint(); }
  }
  
  // Only set direction if it is not a direct conflict with the current direction
  public void setDirection (char d) { direction = d; }
  
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
    if (hitFront(x, y)) {
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
  
  private Boolean hitWall (int x, int y) {
    return x < 0 || x > (BOARD_SIZE-1) || y < 0 || y > (BOARD_SIZE-1);
  }
  
  private Boolean hitFront (int x, int y) {
    return x == body.get(0).getX() && y == body.get(0).getY();
  }
  
  public Boolean bodyInterfere (int x, int y) {
    for (SnakePoint p : body) {
      if (p.getX() == x && p.getY() == y) { return true; }
    }
    
    return false;
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
final Integer[] SPEED_VALS = {10, 9, 8, 6, 1};
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
