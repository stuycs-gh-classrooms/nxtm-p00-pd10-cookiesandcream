int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float K_CONSTANT = 1;
float D_COEF = 0.1;
float V_INITIAL = 5;

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

FixedOrb star;
Orb[] orbs;
OrbNode o0, o1, o2;


void setup()
{
  size(600, 600);
  orbs = new Orb[NUM_ORBS];

  //Simulations
  gravitySetup(V_INITIAL);
}//setup


void draw()
{
  background(255);
  displayMode();

  //Array
  for (int i = 0; i < orbs.length; i++) {
    orbs[i].display();
  }
  
  gravitySim();

  //Linked list
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
}//displayMode

void gravitySetup(float v) {
  star = new FixedOrb(width/2, height/2, 200, 100);
  orbs[0] = star;

  //populate
  for (int i = 1; i < orbs.length; i++) {
    orbs[i] = new Orb();
  }

  for (int i = 1; i < orbs.length; i++) {
    float deg = random(0, 360);
    float vx =  v * cos(radians(deg));
    float vy = v * cos(radians(deg));
    PVector vel = new PVector(vx, vy);
    orbs[i].velocity = vel;
  }
}//gravitySetup

void gravitySim() {
  for (int i = 1; i < orbs.length; i++) {
    PVector gf = orbs[i].getGravity(star, G_CONSTANT);
    orbs[i].applyForce(gf);
  }

  for (int i = 1; i < orbs.length; i++) {
    orbs[i].move(toggles[BOUNCE]);
  }
}//gravitySim
