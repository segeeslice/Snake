import java.util.*;

void setup () {
  // Prelim
  size(500, 500);
  stroke(255);
  strokeWeight(2);
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
  if (playing) { // Play the game
    background(100);
    
    // Draw snake
    fill(snake.getColor());
    for (SnakePoint p : snake.getBody()) {
      rect(p.getXCoord(), p.getYCoord(), SEG_SIZE, SEG_SIZE);
    }
    
    // Draw food
    fill(food.getColor());
    rect(food.getXCoord(), food.getYCoord(), SEG_SIZE, SEG_SIZE);
    
    // Only move at certain intervals, but keep framerate high
    // to lessen input latency
    if (frameCount % 5 == 1) {
      playing = snake.moveAuto();
      
      if (snake.eating(food)) {
        newFood();
        snake.addPoints(3);
      }
    }
  } else { // Display play button    
    stroke(50);
    if (!mouseOverPlay()) {
      fill(200);
    } else {
      fill (255);
    }
    ellipse(250, 250, PLAY_BUTTON_DIAM, PLAY_BUTTON_DIAM);
    
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

void mousePressed () {
  // If play button is pressed
  if (mouseOverPlay()) {
    snake = new Snake();
    newFood();
    playing = true;
  }
}

// Utility functions

Boolean mouseOverPlay () {
  float disX = 250 - mouseX;
  float disY = 250 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < PLAY_BUTTON_DIAM/2 ) {
    return true;
  } else {
    return false;
  }
}
