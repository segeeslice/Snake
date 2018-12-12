import java.util.*;

// Total grid is 500 x 500
// Grid is 25 x 25 with boxes of size 20
// Defined more in SnakeClass

Snake snake = new Snake ();;
Boolean good = true;

void setup () {
  size(500, 500);
  background(100);
  stroke(255);
  fill(255);
  rectMode(CORNER);
  frameRate(60);
}

void draw () {
  if (good) {
    background(100);
    
    for (SnakePoint p : snake.getBody()) {
      rect(p.getXCoord(), p.getYCoord(), BOX_SIZE, BOX_SIZE);
    }
    
    // Only move at certain intervals, but keep framerate high
    // to lessen input latency
    if (frameCount % 5 == 1) {
      good = snake.moveAuto();
    }
  }
}

void keyPressed () {
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
