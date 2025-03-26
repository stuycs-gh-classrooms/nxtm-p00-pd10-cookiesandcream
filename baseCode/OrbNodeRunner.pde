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

//Toggles
int MOVING = 0;
int BOUNCE = 1;

//Simulations
int GRAVITY = 2;
int SPRING = 3;
int DRAGF = 4;
int ELECTROSTATIC = 5;
int COMBINATION = 6;
int sim = GRAVITY; //default simulation

//Toggles
boolean[] toggles = new boolean[6];
String[] mode = {"Moving", "Bounce", "Gravity", "Spring", "Drag", "Electrostatic"};

//Array
FixedOrb star;
Orb[] orbs;

//Linked list
OrbNode o0, o1, o2;


void setup()
{
  size(600, 600);
  orbs = new Orb[NUM_ORBS];

  //Simulations
  if (sim == GRAVITY) {
    gravitySetup(V_INITIAL);
  }
}//setup


void draw()
{
  background(255);
  displayToggle();

  //Array
  for (int i = 0; i < orbs.length; i++) {
    orbs[i].display();
  }

  if (toggles[MOVING]) {
    gravitySim();
  }
  
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
    sim = GRAVITY;
  }
  if (key == '2') {
    sim = SPRING;
  }
  if (key == '3') {
    sim = DRAGF;
  }
  if (key == '4') {
    sim = ELECTROSTATIC;
  }
  if (key == '5') {
    sim = COMBINATION;
  }
}//keyPressed


void displayToggle()
{
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m] || sim == m) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(mode[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(mode[m], x+2, 2);
    x+= w+5;
  }
}//displayMode

void gravitySetup(float vi) {
  star = new FixedOrb(width/2, height/2, 200, 100);
  orbs[0] = star;

  //populate
  for (int i = 1; i < orbs.length; i++) {
    orbs[i] = new Orb();
  }

  for (int i = 1; i < orbs.length; i++) {
    //randomize the direction of initial v
    float deg = random(0, 360);
    float vx =  vi * cos(radians(deg));
    float vy = vi * cos(radians(deg));
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
