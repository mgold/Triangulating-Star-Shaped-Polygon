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

    Point(float _x, float _y, int _id, int _pt){
        x = _x;
        y = _y;
        id = _id;
        pt = _pt;
        r = 5;

        angle = atan2(KERNELY-y, KERNELX-x);
        kernelDist = dist(KERNELX, KERNELY, x, y);
        links = new ArrayList();
    }

    int compareTo(Point other){
        return int(10000*(angle - other.angle));
    }

    void setConvex(boolean _convex){
        if (pt == PT_REFLEX || pt == PT_CONVEX || pt == PT_ASSIGN){
            pt = _convex ? PT_CONVEX : PT_REFLEX;
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

    void draw(){
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
