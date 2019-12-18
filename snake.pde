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

  // Init speed setting functionality
  cycleSpeed();
}

void draw () {
  background(100);
  scoreboard();

  // --- GAME ---
  if (playing) {
    drawSnake();
    drawFood();
    speedButton.draw();
    moveSnake();

  } else if (snakeDied) {
    drawSnake();
    drawFood();
    playButton.draw();
    viewBoardButton.draw();
    viewBoardExitButton.draw(); // TODO: remove
    speedButton.draw();

  } else {
    playButton.draw();
    viewBoardButton.draw(); // TODO: remove
    viewBoardExitButton.draw(); // TODO: remove
    speedButton.draw();
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
}

// ---- UI ELEMENTS ----

void scoreboard () {
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

void drawSnake () {
  for (SnakePoint p : snake.getBody()) {
    fill(p.getColor());
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
Boolean mouseOverPlay () {
  float disX = 250 - mouseX;
  float disY = 250 + SCORE_HEIGHT - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < PLAY_BUTTON_DIAM/2) {
    return true;
  } else {
    return false;
  }
}

Boolean mouseOverSpeed() {
  int w = 100;
  int h = SCORE_HEIGHT/2+10;

  int x1 = 10;
  int y1 = 10;
  int x2 = w + x1;
  int y2 = h + y1;

  return (mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y2);
}
