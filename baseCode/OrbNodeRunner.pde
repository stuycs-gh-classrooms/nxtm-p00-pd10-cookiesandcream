int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float K_CONSTANT = 1;
float D_COEF_AIR = 0.1;
float D_COEF_WATER = 0.3;
float D_COEF_HONEY = 0.7;
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
int prevSim = GRAVITY;

//Toggles
boolean[] toggles = new boolean[7];
String[] mode = {"Moving", "Bounce", "Gravity", "Spring", "Drag", "Electrostatic", "Combination"};

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
  if (sim == GRAVITY || sim == DRAGF || sim == ELECTROSTATIC || sim == COMBINATION) {
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
  if (prevSim != sim) {
    if (sim == GRAVITY || sim == DRAGF) {
      listSetup(V_INITIAL);
    } else if (sim == ELECTROSTATIC || sim == COMBINATION) {
      listSetup(0);
    }
    prevSim = sim;
  }

  if (sim == DRAGF || sim == COMBINATION) {
    fill(0, 256, 0);
    rect(0, 30, width/2, height/2-30);
    fill(150, 75, 0);
    rect(width/2, height/2, width/2, height/2);
  }

  //Array
  if (sim == GRAVITY || sim == DRAGF || sim == ELECTROSTATIC || sim == COMBINATION) {
    for (int i = 0; i < orbs.length; i++) {
      orbs[i].display();
    }
  }

  if (sim == SPRING) {
    //println("sim is correct");
    slinky.display();
  }

  if (sim == ELECTROSTATIC || sim == COMBINATION) {
    chargeDisplay();
  }

  if (toggles[MOVING]) {
    if (sim == GRAVITY) {
      gravitySim();
    }

    if (sim == SPRING) {
      springSim();
    }

    if (sim == DRAGF) {
      dragSim();
    }

    if (sim == ELECTROSTATIC) {
      electroSim();
    }

    if (sim == COMBINATION) {
      combinationSim();
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
  float x = 0; // Starting position for buttons(left side of button
  for (int m = 2; m < toggles.length; m++) { // Start with simulation buttons on the left
    float w = textWidth(mode[m]); //for current one
    if (mouseX > x && mouseX < x + w && mouseY > 0 && mouseY < 20) { // Increment based on wordlength
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
        sim = COMBINATION; // Button doesn't work very well. The calculation process is hard because not uniform button lengths, I tried to fix it but didn
      }
    } //mouse boolean
    x += w;  // Move x position for next button
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
  int first = 0;
  if (sim == GRAVITY || sim == COMBINATION) {
    star = new FixedOrb(width/2, height/2, 200, 100, 0);
    orbs[0] = star;
    first = 1;
  }
  if (sim == DRAGF || sim == ELECTROSTATIC) {
    first = 0;
  }

  //populate
  for (int i = first; i < orbs.length; i++) {
    orbs[i] = new Orb();
  }

  for (int i = first; i < orbs.length; i++) {
    //randomize the direction of initial v
    float deg = random(0, 360);
    float vx =  vi * cos(radians(deg));
    float vy = vi * cos(radians(deg));
    PVector vel = new PVector(vx, vy);
    orbs[i].velocity = vel;
  }
  //println(orbs[0].center);

  //set color to indicate charges
  if (sim == ELECTROSTATIC || sim == COMBINATION) {
    for (int i = 0; i < orbs.length; i++) {
      if (orbs[i].charge > 0) {
        orbs[i].c = color(255, 0, 0);
        fill(0, 0, 0);
        text("+", orbs[i].center.x, orbs[i].center.y);
      } else if (orbs[i].charge < 0) {
        orbs[i].c = color (0, 0, 255);
        fill(0, 0, 0);
        text("-", orbs[i].center.x, orbs[i].center.y);
      }
    }
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
      D_COEF = D_COEF_AIR;
    }
    //println(D_COEF);
    PVector df = orbs[i].getDragForce(D_COEF);
    orbs[i].applyForce(df);
  }

  for (int i = 0; i < orbs.length; i++) {
    orbs[i].move(toggles[BOUNCE]);
  }
}//dragSim

void chargeDisplay() {
  fill(0, 0, 0);
  textSize(30);
  textAlign(CENTER, CENTER);
  for (int i = 0; i < orbs.length; i++) {
    if (orbs[i].charge > 0) {
      text("+", orbs[i].center.x, orbs[i].center.y);
    } else if (orbs[i].charge < 0) {
      text("-", orbs[i].center.x, orbs[i].center.y);
    }
  }
}

void electroSim() {

  for (int i = 0; i < orbs.length; i++) {
    for (int j = 0; j < orbs.length; j++) {
      if (i != j) { //avoid calculating focrce with itself
        PVector ef = orbs[i].getElectro(orbs[j], K_CONSTANT);
        orbs[i].applyForce(ef);
      }
    }
  }

  for (int i = 0; i < orbs.length; i++) {
    orbs[i].move(toggles[BOUNCE]);
  }
}//electroSim

void combinationSim() {
  electroSim();  // Apply electrostatic forces
  chargeDisplay();  // Display charges


  for (int i = 1; i < orbs.length - 1; i++) {  // Loop until the second-to-last orb
    // Apply the spring force between adjacent orbs
    PVector springForce = orbs[i].getSpring(orbs[i + 1], SPRING_LENGTH, SPRING_K/2); // Halved to balance forces, prevent it from dominating
    orbs[i].applyForce(springForce);
    orbs[i + 1].applyForce(springForce.mult(-1));
    //lines and color
    float dist = orbs[i].center.dist(orbs[i+1].center);
    if (dist > SPRING_LENGTH) {
      stroke(0, 255, 0); // Extended (green)
    } else if (dist < SPRING_LENGTH) {
      stroke(255, 0, 0); // Compressed (red)
    } else {
      stroke(0, 0, 255); // Neutral (blue)
    }
    line(orbs[i].center.x + 4, orbs[i].center.y + 4, orbs[i+1].center.x, orbs[i+1].center.y);
    line(orbs[orbs.length - i].center.x - 4, orbs[orbs.length - i].center.y - 4, orbs[orbs.length - i - 1].center.x, orbs[orbs.length - i - 1].center.y);
  }
  float D_COEF = 0;
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
      D_COEF = D_COEF_AIR;
    }
    //println(D_COEF);
    PVector df = orbs[i].getDragForce(D_COEF);
    orbs[i].applyForce(df);
  }
  for (int i = 1; i < orbs.length; i++) {
    PVector gf = orbs[i].getGravity(star, G_CONSTANT/1000); // Smaller to balance out forces, ensures things don't get stuck in purgatory
    orbs[i].applyForce(gf);
  }

  for (int i = 1; i < orbs.length; i++) {
    orbs[i].move(toggles[BOUNCE]);
  }
}
