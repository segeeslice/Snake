import java.util.*;

void setup () {
  // Prelim
  size(500, 550);
  stroke(255);
  strokeWeight(2);
  
  // Game
  rectMode(CORNER);
  frameRate(60);
  
  // Play button
  ellipseMode(CENTER);
  textAlign(CENTER,CENTER);
}

void draw () {
  background(100);
  
  // --- SCOREBOARD ---
  fill(70);
  strokeWeight(0);
  rect(0, 0, 500, SCORE_HEIGHT);
  
  fill(255);
  textSize(23);
  textAlign(RIGHT,CENTER);
  text("Score: " + score.toString(), 490, SCORE_HEIGHT/2);
  
  
  // --- GAME ---
  strokeWeight(2);
  if (playing) {   
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
        score++;
      }
    }
  } else {
    stroke(50);
    if (!mouseOverPlay()) {
      fill(200);
    } else {
      fill (255);
    }
    ellipse(250, 250+SCORE_HEIGHT, PLAY_BUTTON_DIAM, PLAY_BUTTON_DIAM);
    
    fill(0);
    textSize(40);
    textAlign(CENTER,CENTER);
    text("Play", 249, 245+SCORE_HEIGHT);
    
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
    score = 0;
    playing = true;
  }
}

// Utility functions

Boolean mouseOverPlay () {
  float disX = 250 - mouseX;
  float disY = 250 + SCORE_HEIGHT - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < PLAY_BUTTON_DIAM/2 ) {
    return true;
  } else {
    return false;
  }
}
