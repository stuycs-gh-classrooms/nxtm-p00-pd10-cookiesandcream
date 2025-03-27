class OrbList {

  OrbNode front;

  OrbList() {
    front = null;
  }//constructor

  void addFront(OrbNode o) {
    if (front != null) {
      front.previous = o;
      o.next = front;
    }
    front = o;
    //println(front);
    //println("adding front");
  }//addFront

  void populate(int n, boolean ordered) {
    while (front != null) {
      removeFront();
    }

    float x = width/(NUM_ORBS+1);
    for (int i = 0; i < n; i++) {
      OrbNode o = new OrbNode();

      float deg = random(0, 360);
      float vx =  V_INITIAL * cos(radians(deg));
      float vy = V_INITIAL * cos(radians(deg));
      o.velocity = new PVector(vx, vy);

      if (ordered) {
        o.center.x = x;
        x+= width/(NUM_ORBS+1);
        o.center.y = height/2;
      }

      addFront(o);
      //println(o);
      //println(o.center.x, o.center.y);
    }
  }//populate

  void display() {
    OrbNode currentOrb = front;
    //println(currentOrb);
    while (currentOrb != null) {
      currentOrb.display(SPRING_LENGTH);
      currentOrb = currentOrb.next;
      //println("displaying");
    }
  }//display

  void applySprings(int springLength, float springK) {
    OrbNode currentOrb = front.next;
    while (currentOrb != null) {
      if (currentOrb.next != null) {
        currentOrb.applyForce(currentOrb.getSpring(currentOrb.next, springLength, springK));
      }
      if (currentOrb.previous != null) {
        currentOrb.applyForce(currentOrb.getSpring(currentOrb.previous, springLength, springK));
      }
      currentOrb = currentOrb.next;
    }
  }//applySprings

  void applyGravity(Orb other, float gConstant) {
    OrbNode currentOrb = front;
    while (currentOrb != null) {
      currentOrb.applyForce(currentOrb.getGravity(other, gConstant));
      currentOrb = currentOrb.next;
    }
  }//applyGravity

  void run(boolean bounce) {
    //println("run function is called");

    OrbNode currentOrb = front;
    //println(currentOrb);
    while (currentOrb != null) {
      currentOrb.move(bounce);
      currentOrb = currentOrb.next;
    }
    //println("front"+front.center);
    //println("next" + front.next.center);
  }//applySprings

  /*===========================
   removeFront()
   
   Remove the element at the front of the list, i.e.
   after this method is run, the former second element
   should now be the first (and so on).
   =========================*/
  void removeFront() {
    front = front.next;
    front.previous = null;
  }//removeFront

  OrbNode getSelected(int x, int y) {
    OrbNode currentOrb = front;
    OrbNode returned = null;
    while (currentOrb != null) {
      if (dist(currentOrb.center.x, currentOrb.center.y, x, y)<= currentOrb.bsize) {
        returned = currentOrb;
      }
      currentOrb = currentOrb.next;
    }
    //println(returned);
    return returned;
  }//getSelected

  void removeNode(OrbNode o) {
    OrbNode currentOrb = front;
    while (currentOrb != null) {
      if (currentOrb == o) {
        //println("done" + currentOrb);
        break;
      }
      currentOrb = currentOrb.next;
      //(currentOrb);
    }
    if (currentOrb != null) {
      if (currentOrb.previous != null && currentOrb.next != null) {
        currentOrb.next.previous = currentOrb.previous;
        currentOrb.previous.next = currentOrb.next;
        //currentOrb.next = null;
        //currentOrb.previous = null;
      } else if (currentOrb == front) {
        if (currentOrb.next == null && currentOrb.previous == null) {
          front = null;
        } else {
          front = currentOrb.next;
          front.previous = null;
        }
      } else if (currentOrb.next == null) {
        currentOrb.previous.next = null;
        currentOrb.next = null;
      }
    }
  }
}//OrbList
