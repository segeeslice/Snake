// File to contain the base button class definition

abstract class Button {
  // === BASE COMPONENTS ===

  protected color colorPressed;
  protected color colorNeutral;
  protected int strokeAmount;

  protected String text;
  protected color textColor;
  protected int textSize;

  public Button () {
    colorPressed = color(0);
    colorNeutral = color(0);

    strokeAmount = 0;

    text = "";
    textSize = 0;
  }

  public Button setColorPressed (color c) {
    colorPressed = c;
    return this;
  }
  public Button setColorNeutral (color c) {
    colorNeutral = c;
    return this;
  }

  public Button setStrokeAmount (int s) {
    strokeAmount = s;
    return this;
  }

  public Button setText (String t) {
    text = t;
    return this;
  }
  public Button setTextColor (color c) {
    textColor = c;
    return this;
  }
  public Button setTextSize (int ts) {
    textSize = ts;
    return this;
  }


  // === ABSTRACT COMPONENTS ===

  // Indicate if mouse is over this button or not
  abstract Boolean mouseIsOver();

  // Draw the button
  abstract void draw();
}

class RectButton extends Button {
  protected int x1, y1; // Top left rectangle x and y coordinates
  protected int w, h; // Width and height of the rectangle


  public RectButton(int x_in, int y_in, int w_in, int h_in) {
    super();

    x1 = x_in;
    y1 = y_in;
    w = w_in;
    h = h_in;

    strokeAmount = 50;
  }

  // Get bottom right corner x coord
  private int getX2 () {
    return x1 + w;
  }

  // Get bottom right corner y coord
  private int getY2 () {
    return y1 + h;
  }

  private int getCenterX () {
    return x1 + w/2;
  }

  private int getCenterY () {
    return y1 + h/2;
  }

  // === ABSTRACT IMPLEMENTATIONS ===

  final Boolean mouseIsOver () {
    return (mouseX > x1 && mouseX < getX2() && mouseY > y1 && mouseY < getY2());
  }

  final void draw () {
    if (!mouseIsOver()) {
      fill(colorNeutral);
    } else {
      fill(colorPressed);
    }

    stroke(strokeAmount);
    rect(x1, y1, w, h);

    fill(0);
    textSize(this.textSize);
    textAlign(CENTER, CENTER);
    text(this.text, getCenterX(), getCenterY()-2);

    // Reset stroke
    stroke(255); // TODO: Investigate removal
  }
}

//class CircleButton extends Button {

//}
