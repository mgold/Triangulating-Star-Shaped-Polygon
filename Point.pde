final int PT_KERNEL = 0;
final int PT_OLD = 1;
final int PT_CONVEX = 2;
final int PT_REFLEX = 3;
final int PT_ASSIGN = 4;

class Point implements Comparable<Point>{
    float x, y;
    float r;
    int id;
    int pt;

    float angle;
    float kernelDist;
    ArrayList<Link> links;

    Point left;
    Point right;

    Point(float _x, float _y, int _id, int _pt){
        x = _x;
        y = _y;
        id = _id;
        pt = _pt;
        r = 5;

        angle = atan2(KERNELY-y, KERNELX-x);
        kernelDist = dist(KERNELX, KERNELY, x, y);
        links = new ArrayList();

        left = right = null;
    }

    int compareTo(Point other){
        return int(10000*(angle - other.angle));
    }

    void setConvex(){
        if ((pt == PT_REFLEX || pt == PT_CONVEX || pt == PT_ASSIGN)
            && left != null && right != null){
            float theta0 = atan2(y-left.y, x-left.x);
            float theta1 = atan2(y-right.y, x-right.x);
            pt =  sin((theta1-theta0)%TAU) < 0 ? PT_CONVEX : PT_REFLEX;
        }
    }

    void addLinkTo(Point other){
        if (this != other){
            int lt = -1;
            if (pt == PT_KERNEL || other.pt == PT_KERNEL){
                lt = LT_KERNEL;
            }else if(pt == PT_ASSIGN || other.pt == PT_ASSIGN){
                lt = LT_POLYGON;
            }else{
                lt = LT_CURRENT;
            }
            Link link = new Link(this, other, lt);
            this.addLink(link);
            other.addLink(link);
        }
    }

    void addLink(Link link){
        links.add(link);
    }

    void removeKernelLink(){
        for(Link link : links){
            if(link.lt == LT_KERNEL){
                link.lt = LT_GONE;
            }
        }
    }

    void setToOld(){
        pt = PT_OLD;
        for (Link link : links){
            if (link.lt != LT_GONE){
                link.lt = LT_OLD;
            }
        }
    }

    void drawLinks(){
        for (Link link : links){
            link.draw();
        }
    }

    void draw(Point head){
        if (this == head){
            noFill();
            strokeWeight(2);
            stroke(#FF00FF);
            ellipse(x,y,2*r,2*r);
        }
        noStroke();
        switch(pt){
            case PT_KERNEL:
                fill(#FF0000);
                break;
            case PT_OLD:
                fill(#888888);
                break;
            case PT_CONVEX:
                fill(#00FF00);
                break;
            case PT_REFLEX:
                fill(#FF8800);
                break;
            case PT_ASSIGN:
                fill(#000000);
                break;
            default:
                fill(#FFFF00);
        }
        ellipse(x,y,r,r);
        float dx = mouseX -x;
        float dy = mouseY -y;
        if (dx*dx + dy*dy < r*r){
            //println(degrees(angle));
        }
    }

}
