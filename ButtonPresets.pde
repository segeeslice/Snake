// File to contain the button presets for ease of use

// === PRESET CLASSES ===
// NOTE: Done in this way because remaining operations cannot be done in flat file anyway.
//       So it needs to be in its own method, or in a subclass.
//       Subclass seems nicer, so :)

class SpeedButton extends RectButton {
  public SpeedButton () {
    super(10, 10, 100, SCORE_HEIGHT / 2 + 10);

    colorNeutral = color(200);
    colorPressed = color(255);
    strokeAmount = 50;

    text = speedText;
    textColor = color(0);
    textSize = 23;
  }
}

// === PRESET GLOBALS ===

Button speedButton = new SpeedButton();
