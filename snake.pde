import java.util.*;

// Total grid is 500 x 500
// Grid is 25 x 25 with boxes of size 20
// Defined more in SnakeClass

Snake snake = new Snake ();
Boolean playing = false;

final int BUTTON_DIAM = 100;

void setup () {
  // Prelim
  size(500, 500);
  stroke(255);
  strokeWeight(2);
  fill(255);
  background(100);
  
  // Game
  rectMode(CORNER);
  frameRate(60);
  
  // Play button
  ellipseMode(CENTER);
  textSize(40);
  textAlign(CENTER,CENTER);
}

void draw () {
  fill(255);

  if (playing) { // Play the game
    background(100);
    for (SnakePoint p : snake.getBody()) {
      rect(p.getXCoord(), p.getYCoord(), BOX_SIZE, BOX_SIZE);
    }
    
    // Only move at certain intervals, but keep framerate high
    // to lessen input latency
    if (frameCount % 5 == 1) {
      playing = snake.moveAuto();
    }
  } else { // Display play button    
    stroke(50);
    if (!mouseOverPlay()) { fill(200); }
    ellipse(250, 250, BUTTON_DIAM, BUTTON_DIAM);
    
    fill(0);
    text("Play", 249, 245);
    
    stroke(255); // Simply reset stroke after
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

Boolean mouseOverPlay () {
  float disX = 250 - mouseX;
  float disY = 250 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < BUTTON_DIAM/2 ) {
    return true;
  } else {
    return false;
  }
}

void mousePressed () {
  if (mouseOverPlay()) {
    snake = new Snake();
    playing = true;
  }
}
