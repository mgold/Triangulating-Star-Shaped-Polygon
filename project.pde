final int KERNELX = 200;
final int KERNELY = 200;
final int STATEDELAY = 70;
final int LEGENDSPACING = 20;
final color COINSTROKE = #FF00FF;

ArrayList<Point> points;
ArrayList<Point> convexPoints;
Point legend [];
Point kernel;
Point head;
Point from, to;
Coin marker;
Button button;
Ring ring;
int idcounter;

State state; //No enums in Processing
boolean shouldDrawEdges;
boolean shouldDrawKernelRays;
boolean shouldDrawLegend;

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
    convexPoints = new ArrayList();
    ring = new Ring();
    kernel = new Point(KERNELX, KERNELY, 0, PT_KERNEL);
    idcounter = 1;
    state = new State();
    shouldDrawEdges = false;
    shouldDrawKernelRays = false;
    shouldDrawLegend = false;
    head = null;
    marker = null;
    button = new Button(.7*width, width+.5*LEGENDSPACING);

    //Comment out on processing.js
    frame.setTitle("Triangulating a Star-Shaped Polygon with Known Kernel");

    legend = new Point [4];
    legend [0] = new Point(LEGENDSPACING, width+  LEGENDSPACING, -1, PT_CONVEX);
    legend [1] = new Point(LEGENDSPACING, width+2*LEGENDSPACING, -1, PT_REFLEX);
    legend [2] = new Point(LEGENDSPACING, width+3*LEGENDSPACING, -1, PT_CONVEX);
    legend [2].containsKernel = true;
    legend [3] = new Point(LEGENDSPACING, width+4*LEGENDSPACING, -1, PT_OLD);
}

void update(){
    state.tick();
    switch (state.state){
        case BEGIN:
            text("Click here to begin.", 5, width);
            state.timer = 0;
            break;
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
            state.timer = 0;
            break;

        case SORT1:
            //radial sort
            for (int i=0; i<points.size(); i++) {
                for (int j=0; j<points.size() -1; j++) {
                    if (points.get(j).angle > points.get(j+1).angle){
                        Point removed = points.remove(j);
                        points.add(j+1, removed);
                    }
                }
            }
            //linked list of all points on polygon
            for (int i = 0; i < points.size(); i++){
                Point current = points.get(i);
                current.addLinkTo(points.get((i+1)%points.size()));
                kernel.addLinkTo(current);
                current.setRight(points.get((i+1)%points.size()));
                current.right.setLeft(current);
            }
            shouldDrawEdges = true;
            state.next();
        case SORT2:
            text("Polygon by radial sort.", 5, width);
            if (state.timer > 2*STATEDELAY){
                state.next();
            }
            break;

        case CONVEX1:
            for (Point current : points){
                current.setConvex();
                current.setContainsKernel();
                if (current.pt == PT_CONVEX){
                    convexPoints.add(current);
                }
            }
            state.next();
        case CONVEX2:
            text("Convex and reflex vertices.", 5, width);
            if (state.timer > 2*STATEDELAY){
                state.next();
            }
            break;

        case RAYS:
            text("Rays from kernel to vertices.", 5, width);
            shouldDrawKernelRays = true;
            if (state.timer > 2*STATEDELAY){
                state.next();
            }
            break;

        case SETUP:
            from = head = convexPoints.get(0);
            to = convexPoints.get(1);
            marker = new Coin();
            shouldDrawLegend = true;
            button.enableWithLabel("Step»");
            button.setStroke(COINSTROKE);
            state.timer = 0;
            state.next();
            break;

        case PAUSE:
            state.timer = 0;
            break;

        case FLIP:
            if (head.right.right.right == head){
                state.next();
                break;
            }
            state.timer %= STATEDELAY;
            if (state.timer == 0){
                marker.next();
                head = from;
                if (head.pt == PT_CONVEX && !head.containsKernel){
                    head.removeKernelLink();
                    head.left.addLinkTo(head.right);
                    head.left.right = head.right;
                    head.right.left = head.left;
                    head.left.setConvex();
                    head.left.setContainsKernel();
                    head.right.setConvex();
                    head.right.setContainsKernel();
                    int headIndex = convexPoints.indexOf(head);
                    if (head.left.pt == PT_CONVEX &&
                        convexPoints.indexOf(head.left) == -1){
                        convexPoints.add(headIndex, head.left);
                        headIndex++;
                    }
                    if (head.right.pt == PT_CONVEX &&
                        convexPoints.indexOf(head.right) == -1){
                        convexPoints.add(headIndex+1, head.right);
                        to = head.right;
                    }
                    convexPoints.remove(headIndex);
                    Point newHead = head.right;
                    head.setToOld();
                    head = newHead;
                }else{
                    head = head.right;
                }
                state.state = PAUSE;
            }
        break;

        case FINALIZE:
            shouldDrawLegend = false;
            shouldDrawKernelRays = false;
            kernel.setToGone();
            for (Point point : points){
                point.setToFinal();
            }
            marker.disable();
            convexPoints.clear();
            button.enableWithLabel("Reset↺");
            button.setStroke(#FF0000);
            state.next();
            break;
        case FINAL:
            state.timer = 0;
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
        for (Point p : points){
            p.drawLinks();
        }
        /*
        strokeWeight(1);
        stroke(#000000);
        for (int i = 0; i < points.size(); i++){
            Point a = points.get(i);
            Point b = points.get((i+1)%points.size());
            line(a.x, a.y, b.x, b.y);
        }
        */
        strokeWeight(3);
        stroke(#8888FF);
        for (int i = 0; i < convexPoints.size(); i++){
            Point a = convexPoints.get(i);
            Point b = convexPoints.get((i+1)%convexPoints.size());
            line(a.x, a.y, b.x, b.y);
        }
    }

    for (Point point : points) {
        point.draw();
    }
    kernel.draw();

    if (marker != null){
        marker.draw(state.timer/float(STATEDELAY));
    }

    ring.draw();

    button.draw();
    if (shouldDrawLegend){
        for (Point l : legend){
            l.draw();
        }
        textSize(14);
        textAlign(LEFT, CENTER);
        fill(#000000);
        text("Convex Point", 1.5*LEGENDSPACING, width+  LEGENDSPACING);
        text("Reflex Point", 1.5*LEGENDSPACING, width+2*LEGENDSPACING);
        text("Convex Point with Kernel", 1.5*LEGENDSPACING, width+3*LEGENDSPACING);
        text("Already Triangulated", 1.5*LEGENDSPACING, width+4*LEGENDSPACING);
    }

    stroke(#000000);
    strokeWeight(1);
    line(0,width,width,width);

}

void mouseClicked(){
    switch (state.state){
        case BEGIN:
            if (mouseY > width){
                state.next();
            }
            break;
        case ASSIGN1:
        case ASSIGN2:
        case ASSIGN3:
            if (mouseY > width){
                if (points.size() > 2){
                    state.next();
                }
            }else{
                points.add(new Point(mouseX, mouseY,idcounter, PT_ASSIGN));
                idcounter++;
            }
            break;
        case PAUSE:
            if (button.pressed()){
                state.next();
            }
            break;
        case FINAL:
            if (button.pressed()){
                for (Point p : points){
                    p.reset();
                    if (p.pt == PT_CONVEX){
                        convexPoints.add(p);
                    }
                }
                kernel.setAsKernel();
                state.state = SETUP;
            }

        default:
    }

}
