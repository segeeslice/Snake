import java.util.*;

void setup () {
  // Prelim
  size(500, 550);
  stroke(255);
  strokeWeight(2);
  ellipseMode(CENTER);
  
  // Game
  rectMode(CORNER);
  frameRate(120);
}

void draw () {
  background(100);
  scoreboard();
  
  // --- GAME ---
  if (playing) {
    drawSnake();
    drawFood();
    moveSnake();
    
  } else {
    playButton();
    // Settings button here
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
  if (!playing && mouseOverPlay()) {
    snake = new Snake();
    newFood();
    score = 0;
    playing = true;
  }
}

// ---- UI ELEMENTS ----

void playButton () {
  if (!mouseOverPlay()) {
    fill(200);
  } else {
    fill(255);
  }
  
  stroke(50);
  ellipse(250, 250+SCORE_HEIGHT, PLAY_BUTTON_DIAM, PLAY_BUTTON_DIAM);
  
  fill(0);
  textSize(40);
  textAlign(CENTER,CENTER);
  text("Play", 249, 245+SCORE_HEIGHT);
  
  stroke(255); // Reset stroke after
}

void scoreboard () {
  // Box
  fill(70);
  strokeWeight(0);
  rect(0, 0, 500, SCORE_HEIGHT);
  
  // Score text
  fill(255);
  textSize(23);
  textAlign(RIGHT,CENTER);
  text("Score: " + score.toString(), 490, SCORE_HEIGHT/2);
  
  strokeWeight(2); // Reset to original
}

void drawSnake () {
  fill(snake.getColor());
  for (SnakePoint p : snake.getBody()) {
    rect(p.getXCoord(), p.getYCoord(), SEG_SIZE, SEG_SIZE);
  } 
}

void drawFood () {
  fill(food.getColor());
  rect(food.getXCoord(), food.getYCoord(), SEG_SIZE, SEG_SIZE);
}

void moveSnake () {
  // Only move at certain intervals, but keep framerate high
  // to lessen input latency
  if (frameCount % 10 == 1) {
    playing = snake.moveAuto();
    
    if (snake.eating(food)) {
      newFood();
      snake.addPoints(3);
      score++;
    }
  } 
}

// ---- UTIL FUNCTIONS ----

Boolean mouseOverPlay () {
  float disX = 250 - mouseX;
  float disY = 250 + SCORE_HEIGHT - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < PLAY_BUTTON_DIAM/2) {
    return true;
  } else {
    return false;
  }
}
