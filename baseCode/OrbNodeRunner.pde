int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float K_CONSTANT = 1;
float D_COEF = 0.1;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int GRAVITY = 1;
int SPRING = 2;
int DRAGF = 3;
int ELECTROSTATIC = 4;
int COMBINATION = 5;
int BOUNCE = 6;

boolean[] toggles = new boolean[7];
String[] modes = {"Moving", "Gravity", "Spring", "Drag", "Electrostatic",
  "Combination", "Bounce"};

FixedOrb earth;
OrbNode o0, o1, o2;


void setup()
{
  size(600, 600);

  earth = new FixedOrb(width/2, height * 200, 1, 20000);

  o0 = new OrbNode();
  o1 = new OrbNode();
  o2 = new OrbNode();

  o0.next = o1;
  o1.previous = o0;
  o1.next = o2;
  o2.previous = o1;
}//setup


void draw()
{
  background(255);
  displayMode();

  OrbNode currentNode = o0;
  while (currentNode != null) {
    currentNode.display(SPRING_LENGTH);
    currentNode = currentNode.next;
  }

  currentNode = o0;
  while (currentNode != null) {
    currentNode.applySprings(SPRING_LENGTH, SPRING_K);
    currentNode = currentNode.next;
  }
}//draw





void keyPressed()
{
  if (key == ' ') {
    toggles[MOVING] = !toggles[MOVING];
  }
  if (key == 'b') {
    toggles[BOUNCE] = !toggles[BOUNCE];
  }
  if (key == '1') {
    toggles[GRAVITY] = !toggles[GRAVITY];
  }
  if (key == '2') {
    toggles[SPRING] = !toggles[SPRING];
  }
  if (key == '3') {
    toggles[DRAGF] = !toggles[DRAGF];
  }
  if (key == '4') {
    toggles[ELECTROSTATIC] = !toggles[ELECTROSTATIC];
  }
  if (key == '5') {
    toggles[COMBINATION] = !toggles[COMBINATION];
  }
}//keyPressed


void displayMode()
{
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 2);
    x+= w+5;
  }
}//display
