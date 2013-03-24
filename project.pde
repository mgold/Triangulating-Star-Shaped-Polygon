import java.util.*;

final int KERNELX = 200;
final int KERNELY = 200;
final int STATEDELAY = 150;

ArrayList<Point> points;
Point kernel;
Point head;
Coin marker;
int idcounter;

State state; //No enums in Processing
boolean shouldDrawEdges;

//TODO: write my own sort because Java's don't work in processing.js
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


boolean rightTurn(Point a, Point b, Point c){
    //matrix determinant
    return a.x*b.y + b.x*c.y + c.x*a.y - a.x*c.y - b.x*a.y - c.x*b.y > 0;
}

void setup(){
    size(400,500);
    textAlign(LEFT, TOP);
    textSize(24);

    points = new ArrayList();
    kernel = new Point(KERNELX, KERNELY, 0, PT_KERNEL);
    idcounter = 1;
    state = new State();
    shouldDrawEdges = false;
    head = null;
    marker = null;

    //Comment out on processing.js
    frame.setTitle("Triangulating a Star-Shaped Polygon with Known Kernel");
}

void update(){
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
            for (int i = 0; i < points.size(); i++){
                Point current = points.get(i);
                current.addLinkTo(points.get((i+1)%points.size()));
                kernel.addLinkTo(current);
                current.right = points.get((i+1)%points.size());
                current.right.left = current;
            }
            for (Point current : points){
                current.setConvex();
                current.setContainsKernel();
            }
            head = points.get(0);
            marker = new Coin(head.left);
            state.next();
            state.timer = 1;
            break;
        case FLIP:
            if (head.right.right.right == head){
                state.next();
                break;
            }
            state.timer %= STATEDELAY;
            if (state.timer == 0){
                marker.next();
                if (head.pt == PT_CONVEX && !head.containsKernel){
                    head.removeKernelLink();
                    head.left.addLinkTo(head.right);
                    head.left.right = head.right;
                    head.right.left = head.left;
                    head.left.setConvex();
                    head.left.setContainsKernel();
                    head.right.setConvex();
                    head.right.setContainsKernel();
                    Point newHead = head.right;
                    head.setToOld();
                    head = newHead;
                }else{
                    head = head.right;
                }
            }
        break;

        case FINAL:
            kernel.setToGone();
            for (Point point : points){
                point.setToFinal();
            }
            marker.disable();
            break;
        default:
            println("Unknown state: "+state.state);
    }
}

void draw(){
    background(#FFFFFF);
    fill(#000000);

    update();

    if (shouldDrawEdges){
        kernel.drawLinks();
        for (Point point : points) {
            point.drawLinks();
        }
    }

    for (Point point : points) {
        point.draw(head);
    }
    kernel.draw(head);

    if (marker != null){
        marker.draw(state.timer/float(STATEDELAY));
    }

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
            points.add(new Point(mouseX, mouseY,idcounter, PT_ASSIGN));
            idcounter++;
        }
        break;
        case FLIP:
        if (mouseY > width){
            state.timer = 0;
        }
        default:
    }

}
