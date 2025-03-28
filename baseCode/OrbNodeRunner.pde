int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float K_CONSTANT = 1;
float D_COEF_AIR = 0.1;
float D_COEF_WATER = 0.4;
float D_COEF_HONEY = 0.9;
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
OrbList slinky;


void setup()
{
  size(600, 600);
  orbs = new Orb[NUM_ORBS];

  //Simulations
  if (sim == GRAVITY || sim == DRAGF) {
    listSetup(V_INITIAL);
  }
  //LINKED LIST
  slinky = new OrbList();
  slinky.populate(NUM_ORBS, true);
}//setup


void draw()
{
  background(255);
  displayToggle();
  if (sim == DRAGF) {
    fill(0, 256, 0);
    rect(0, 30, width/2, height/2-30);
    fill(150, 75, 0);
    rect(width/2, height/2, width/2, height/2);
  }
<<<<<<< HEAD
  
=======

>>>>>>> ec16facc2c8bd5c16c2d9198a96686e1e083a000
  //Array
  if (sim == GRAVITY || sim == DRAGF) {
    for (int i = 0; i < orbs.length; i++) {
      orbs[i].display();
    }
  }
  if (sim == SPRING) {
    //println("sim is correct");
    slinky.display();
  }

  if (toggles[MOVING]) {
    if (sim == GRAVITY) {
      gravitySim();
    }
    if (sim == SPRING) {
      springSim();
    }
<<<<<<< HEAD
    if (sim == DRAGF){
=======
    if (sim == DRAGF) {
>>>>>>> ec16facc2c8bd5c16c2d9198a96686e1e083a000
      dragSim();
    }
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

void mousePressed() {
  int x = 0; // Starting position for buttons
  for (int m = 2; m < toggles.length; m++) { // Start with simulation buttons on the left
    float w = textWidth(mode[m]);
    if (mouseX > x && mouseX < x + w + 5 && mouseY > 0 && mouseY < 20) { // Increment based on wordlength
      // Change simulation mode based on button clicked
      if (m == GRAVITY) {
        sim = GRAVITY;
      } else if (m == SPRING) {
        sim = SPRING;
      } else if (m == DRAGF) {
        sim = DRAGF;
      } else if (m == ELECTROSTATIC) {
        sim = ELECTROSTATIC;
      } else if (m == COMBINATION) {
        sim = COMBINATION;
      }
    } //mouse boolean
    x += w + 5;  // Move x position for next button
  } //for

  x = width - 2; // Move to the far right for the last two buttons
  for (int m = 0; m < 2; m++) {
    float w = textWidth(mode[m]);  // Get width of button

    // Check if the mouse press is within the button's area
    if (mouseX > x - w && mouseX < x && mouseY > 0 && mouseY < 20) {
      if (m == MOVING || m == BOUNCE) {
        toggles[m] = !toggles[m];  // Toggle the state of the button
      }
    }

    x -= w + 5;  // Update x position for next button
  }//for loop
}//mousePressed


void displayToggle()
{
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int x = 0;

  for (int m=2; m<toggles.length; m++) {
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
  x = width - 2; // Move it away from the side wall
  for (int m=0; m<2; m++) {
    //set box color
    if (toggles[m] || sim == m) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(mode[m]);
    rect(x-w, 0, w+5, 20);
    fill(0);
    text(mode[m], x+2-w, 2);
    x -= w+5;
  }
}//displayMode

void listSetup(float vi) {
  int f = 0;
  if (sim == GRAVITY) {
    star = new FixedOrb(width/2, height/2, 200, 100);
    orbs[0] = star;
    f = 1;
  }
  if (sim == DRAGF) {
    f = 0;
  }

  //populate
  for (int i = f; i < orbs.length; i++) {
    orbs[i] = new Orb();
  }

  for (int i = f; i < orbs.length; i++) {
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

void springSim() {
  //println("springSim running");
  slinky.applySprings(SPRING_LENGTH, SPRING_K);
  slinky.run(toggles[BOUNCE]);
}//springSim


void dragSim() {
  float D_COEF = 0;
<<<<<<< HEAD
  for (int i = 0; i < orbs.length; i++){
    if (orbs[i].center.x > 0 && 
        orbs[i].center.x < width/2 &&
        orbs[i].center.y > 30 &&
        orbs[i].center.y < height/2){
          D_COEF = D_COEF_WATER;
        }
    if (orbs[i].center.x > width/2 && 
        orbs[i].center.x < width &&
        orbs[i].center.y > height/2 &&
        orbs[i].center.y < height){
          D_COEF = D_COEF_HONEY;
        }
    else{
=======
  for (int i = 0; i < orbs.length; i++) {
    if (orbs[i].center.x > 0 &&
      orbs[i].center.x < width/2 &&
      orbs[i].center.y > 30 &&
      orbs[i].center.y < height/2) {
      D_COEF = D_COEF_WATER;
    }
    if (orbs[i].center.x > width/2 &&
      orbs[i].center.x < width &&
      orbs[i].center.y > height/2 &&
      orbs[i].center.y < height) {
      D_COEF = D_COEF_HONEY;
    } else {
>>>>>>> ec16facc2c8bd5c16c2d9198a96686e1e083a000
      D_COEF = D_COEF_AIR;
    }
    println(D_COEF);
    PVector df = orbs[i].getDragForce(D_COEF);
    orbs[i].applyForce(df);
  }
  for (int i = 1; i < orbs.length; i++) {
    orbs[i].move(toggles[BOUNCE]);
  }
}//dragSim
