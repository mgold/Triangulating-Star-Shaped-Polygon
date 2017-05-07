final int KERNELX = 200;
final int KERNELY = 200;
final int STATEDELAY = 70;
final int LEGENDSPACING = 20;
final int RINGRADIUS = 180;
final int FENCERADIUS = 2*RINGRADIUS-5;
final int INTROTEXTSIZE = 24;

final color COINSTROKE = #FF00FF;
final color CONVEXFILL = #008800;
final color REFLEXFILL = #FF8800;
final color KERNELFILL = #FF0000;
final color CHAINSTROKE= #8888FF;

ArrayList<Point> points;
ArrayList<Point> convexPoints;
Point legend [];
Point kernel;
Point head;
Point from, to;
Coin marker;
Ring ring;
int idcounter;
float offset;

State state; //No enums in Processing
boolean shouldDrawEdges;
boolean shouldDrawKernelRays;
boolean shouldDrawLegend;
boolean shouldDrawChain;
boolean shouldDrawFence;

float bound(float lo, float x, float hi){
    return min(hi, max(lo, x));
}

boolean rightTurn(Point a, Point b, Point c){
    //matrix determinant
    return a.x*b.y + b.x*c.y + c.x*a.y - a.x*c.y - b.x*a.y - c.x*b.y > 0;
}

void newPoint(){
    if (dist(KERNELX, KERNELY, mouseX, mouseY) < RINGRADIUS-3){
        points.add(new Point(mouseX, mouseY,idcounter, PT_ASSIGN));
        idcounter++;
    }
}

void setup(){
    size(400,500);
    textAlign(LEFT, TOP);
    textSize(INTROTEXTSIZE);

    points = new ArrayList();
    convexPoints = new ArrayList();
    ring = new Ring();
    kernel = new Point(KERNELX, KERNELY, 0, PT_KERNEL);
    idcounter = 1;
    state = new State();
    shouldDrawEdges = false;
    shouldDrawKernelRays = false;
    shouldDrawLegend = false;
    shouldDrawChain = false;
    shouldDrawFence = false;
    head = null;
    marker = null;
    offset = 0;

    try {
        surface.setTitle("Triangulating a Star-Shaped Polygon with Known Kernel");
    } catch (exception) {
        // do nothing - this line fails in processing.js
    }

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
            fill(#000000);
            text("The red point is in the ", 5, width);
            offset = textWidth("The red point is in the ");
            fill(KERNELFILL);
            text("kernel", 5+offset, width);
            offset += textWidth("kernel");
            fill(#000000);
            text(".", 5+offset, width);
            if (state.timer > 2*STATEDELAY){
                state.next();
            }
            break;
        case ASSIGN2:
            shouldDrawFence = true;
            text("Click in the ring to add points.", 5, width);
            if (state.timer > 2*STATEDELAY){
                state.next();
            }
            break;
        case ASSIGN3:
            text("Click here when you're done.", 5, width);
            state.timer = 0;
            break;

        case SORT1:
            shouldDrawFence = false;
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
            textSize(16);
            fill(#888888);
            text("Click below the line to progress.", 5, width + INTROTEXTSIZE+5);
            fill(#000000);
            textSize(INTROTEXTSIZE);
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
            fill(CONVEXFILL);
            text("Convex ", 5, width);
            offset = textWidth("Convex ");
            fill(#000000);
            text("and ", 5+offset, width);
            offset += textWidth("and ");
            fill(REFLEXFILL);
            text("reflex ", 5+offset, width);
            offset += textWidth("reflex ");
            fill(#000000);
            text("vertices. ", 5+offset, width);
            textSize(16);
            fill(#888888);
            text("Keep clicking...", 5, width + INTROTEXTSIZE+5);
            fill(#000000);
            textSize(INTROTEXTSIZE);
            break;

        case CCHAIN:
            shouldDrawChain = true;
            fill(#000000);
            text("Concrete ", 5, width);
            offset = textWidth("Concrete ");
            fill(CHAINSTROKE);
            text("chain ", 5+offset, width);
            offset += textWidth("chain ");
            fill(#000000);
            text("of convex vertices", 5+offset, width);
            break;

        case ACHAIN:
            ring.enable();
            fill(#000000);
            text("Abstract ", 5, width);
            offset = textWidth("Abstract ");
            fill(CHAINSTROKE);
            text("chain ", 5+offset, width);
            offset += textWidth("chain ");
            fill(#000000);
            text("of convex vertices", 5+offset, width);
            break;

        case RAYS:
            shouldDrawKernelRays = true;
            fill(KERNELFILL);
            text("Rays ", 5, width);
            offset = textWidth("Rays ");
            fill(#000000);
            text("from kernel to vertices.", 5+offset, width);
            break;

        case SELECTED1:
            from = head = convexPoints.get(0);
            to = convexPoints.get(1);
            marker = new Coin();
            state.next();
        case SELECTED2:
            fill(COINSTROKE);
            text("Selected ", 5, width);
            offset = textWidth("Selected ");
            fill(#000000);
            text("convex point.", 5+offset, width);
            break;

        case SETUP:
            marker.unfreeze();
            shouldDrawLegend = true;
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
            ring.disable();
            kernel.setToGone();
            for (Point point : points){
                point.setToFinal();
            }
            marker.disable();
            convexPoints.clear();
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
    noStroke();

    update();

    if (shouldDrawFence){
        stroke(#000000);
        noFill();
        ellipse(KERNELX, KERNELY, FENCERADIUS, FENCERADIUS);
        fill(#000000);
        noStroke();
    }

    if (shouldDrawEdges){
        for (Point p : points){
            p.drawLinks();
        }
    }

    if(shouldDrawChain){
        strokeWeight(3);
        stroke(CHAINSTROKE);
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

    if (state.state == PAUSE || state.state == FLIP){
        textSize(16);
        fill(#888888);
        text("Click to ", .7*width, width+20);
        offset = textWidth("Click to ");
        fill(COINSTROKE);
        text("step", .7*width+offset, width+20);
        offset += textWidth("step");
        fill(#888888);
        text("»", .7*width+offset, width+20);
    }

    if (state.state == FINAL){
        textSize(16);
        fill(#888888);
        text("Click to ", .7*width, width+20);
        offset = textWidth("Click to ");
        fill(#FF0000);
        text("reset", .7*width+offset, width+20);
        offset += textWidth("reset");
        fill(#888888);
        text("↺", .7*width+offset, width+20);
    }

    stroke(#000000);
    strokeWeight(1);
    line(0,width,width,width);

}

void mouseClicked(){
    switch (state.state){
        case BEGIN:
        case SORT2:
        case CONVEX2:
        case CCHAIN:
        case ACHAIN:
        case RAYS:
        case SELECTED2:
            if (mouseY > width){
                state.next();
            }
            break;

        case ASSIGN1:
        case ASSIGN2:
            if (mouseY > width){
                state.next();
            }else {
                newPoint();
            }
            break;

        case ASSIGN3:
            if (mouseY > width){
                if (points.size() > 2){
                    state.next();
                }
            }else {
                newPoint();
            }
            break;

        case PAUSE:
            if (mouseY > width){
                state.next();
            }
            break;

        case FINAL:
            if (mouseY > width){
                kernel.setAsKernel();
                for (Point p : points){
                    p.reset();
                    p.addLinkTo(kernel);
                    if (p.pt == PT_CONVEX){
                        convexPoints.add(p);
                    }
                }
                from = head = convexPoints.get(0);
                to = convexPoints.get(1);
                ring.enable();
                shouldDrawKernelRays = true;
                state.state = SETUP;
            }
            break;

        default:
    }

}
