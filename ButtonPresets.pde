// File to contain the button presets for ease of use

// === CONST VARS ===
// Basic positional things can be changed here
// Further changes must be made within constructors

// Play button
final int PLAY_WIDTH = 100;
final int PLAY_HEIGHT = 70;
final int PLAY_X = BOARD_CENTER_X - (PLAY_WIDTH / 2);
final int PLAY_Y = BOARD_CENTER_Y - (PLAY_HEIGHT / 2);

// Speed button
final int SPEED_X = 8;
final int SPEED_Y = 8;
final int SPEED_WIDTH = 100;
final int SPEED_HEIGHT = SCORE_HEIGHT - (SPEED_Y * 2);


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

// === PRESET GLOBALS ===

Button speedButton = new SpeedButton();
Button playButton = new PlayButton();
