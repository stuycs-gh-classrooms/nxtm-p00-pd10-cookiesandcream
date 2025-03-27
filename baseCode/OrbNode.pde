class OrbNode extends Orb
{
  //attributes aka instance variables
  OrbNode next;
  OrbNode previous;

void display(int springLength)
  {
    super.display();
    //println("displaying");
    // Draw line to the next OrbNode
    if (next != null) {
      float dist = center.dist(next.center);
      if (dist > springLength) {
        stroke(0, 255, 0); // extended (green)
      } else if (dist < springLength) {
        stroke(255, 0, 0); // compressed (red)
      } else {
        stroke(0, 0, 255); // neutral (blue)
      }
      line(center.x - 2.5, center.y - 2.5, next.center.x - 2.5, next.center.y - 2.5);
    }

    // Draw line to the previous OrbNode
    if (previous != null) {
      float dist = center.dist(previous.center);
      if (dist > springLength) {
        stroke(0, 255, 0); // extended (green)
      } else if (dist < springLength) {
        stroke(255, 0, 0); // compressed (red)
      } else {
        stroke(0, 0, 255); // neutral (blue)
      }
      line(center.x + 2.5, center.y + 2.5, previous.center.x + 2.5, previous.center.y + 2.5);
    }
  }


  // Apply spring force to next and previous nodes
  void applySprings(int springLength, float springK)
  {
    if (next != null) {
      PVector springForce = getSpring(next, springLength, springK);
      applyForce(springForce);
    }
    if (previous != null) {
      PVector springForce = getSpring(previous, springLength, springK);
      applyForce(springForce);
    }
  }
}//OrbNode
