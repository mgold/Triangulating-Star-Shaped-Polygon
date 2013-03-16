import java.util.*;

final int KERNELX = 200;
final int KERNELY = 200;
final int STATEDELAY = 120;

ArrayList<Point> points;
Point kernel;
int idcounter;

State state; //No enums in Processing
boolean shouldDrawEdges;

//TODO: make this work, then sort points, then draw fake triangulation
/*
void bubbleSort(ArrayList<Point> sortme){
  for (int i=0; i<sortme.size(); i++) {
    for (int j=i+1; j<sortme.size(); j++) {
      Point current = sortme.get(i);
      Point next = sortme.get(j);

      if (current.angle < next.angle){
          //swap
          sortme.remove(current
          Point temp = current;
          array[i] = next;
          array[j] = temp;
      }
    }
  }
}
*/

float bound(float lo, float x, float hi){
    return min(hi, max(lo, x));
}

void setup(){
    size(400,600);
    textAlign(LEFT, TOP);
    textSize(24);

    points = new ArrayList();
    kernel = new Point(KERNELX, KERNELY, 0);
    kernel.fillColor = #FF0000;
    idcounter = 1;
    state = new State();
    shouldDrawEdges = false;

    //Comment out on processing.js
    frame.setTitle("Triangulating a Star-Shaped Polygon with Known Kernel");
}

void draw(){
    background(#FFFFFF);

    fill(#000000);
    state.tick();
    switch (state.state){
        case ASSIGN1:
            text("The red point is in the kernel.", 5, width);
            if (state.timer > STATEDELAY){
                state.next();
            }
            break;
        case ASSIGN2:
        text("Click in the box to add points.", 5, width);
        if (state.timer > STATEDELAY){
            state.next();
        }
        break;
        case ASSIGN3:
        text("Click here when you're done.", 5, width);
        if (state.timer > STATEDELAY){
            state.next();
        }
        break;
        case ASSIGN4:
        break;
        case SORT:
        Collections.sort(points);
        shouldDrawEdges = true;
        break;
        default:
        println(state.state);
    }

    if (shouldDrawEdges){
        Point current = points.get(0);
        Point next = points.get(1);
        for (int i = 2; i < points.size()+2; i++){
            stroke(#000000);
            line(current.x, current.y, next.x, next.y);
            stroke(128,128,256);
            line(current.x, current.y, KERNELX, KERNELY);
            current = next;
            next = points.get(i%points.size());
        }
    }

    for (Point point : points) {
        point.draw();
    }
    kernel.draw();
    stroke(#000000);
    line(0,width,width,width);

}

void mouseClicked(){
    switch (state.state){
        case ASSIGN1:
        case ASSIGN2:
        case ASSIGN3:
        case ASSIGN4:
        if (mouseY > width){
            if (points.size() > 2){
                state.next();
            }
        }else{
            points.add(new Point(mouseX, mouseY,idcounter));
            idcounter++;
        }
        break;
    }

}
