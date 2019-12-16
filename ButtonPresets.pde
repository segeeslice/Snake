// File to contain the button presets for ease of use

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

Button speedButton = new SpeedButton();
