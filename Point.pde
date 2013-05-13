final int PT_KERNEL = 0;
final int PT_OLD = 1;
final int PT_CONVEX = 2;
final int PT_REFLEX = 3;
final int PT_ASSIGN = 4;
final int PT_GONE = 5;
final int PT_FINAL = 6;

class Point implements Comparable<Point>{
    float x, y;
    float r, R, dr;
    float rx, ry;
    int id;
    int pt;

    float angle;
    float kernelDist;
    ArrayList<Link> links;

    Point left, right;
    Point origLeft, origRight;
    boolean containsKernel;

    Point(float _x, float _y, int _id, int _pt){
        x = _x;
        y = _y;
        id = _id;
        pt = _pt;
        R = r = 5;
        dr = 0;

        angle = atan2(KERNELY-y, KERNELX-x);
        kernelDist = dist(KERNELX, KERNELY, x, y);
        links = new ArrayList();
        rx = -RINGRADIUS*cos(   angle) + KERNELX;
        ry =  RINGRADIUS*sin(-1*angle) + KERNELY;

        left = right = origLeft = origRight = null;
        containsKernel = pt == PT_KERNEL ? true : false;
    }

    int compareTo(Point other){
        return int(10000*(angle - other.angle));
    }

    void setLeft(Point l){
        origLeft = left = l;
    }

    void setRight(Point r){
        origRight = right = r;
    }

    void reset(){
        links.clear();
        left = origLeft;
        right = origRight;
        pt = PT_ASSIGN;
        setConvex();
        setContainsKernel();
        addLinkTo(left);
        addLinkTo(right);
    }

    void setConvex(){
        if ((pt == PT_REFLEX || pt == PT_CONVEX || pt == PT_ASSIGN)
            && left != null && right != null){
            int oldPT = pt;
            pt =  rightTurn(left, this, right) ? PT_CONVEX : PT_REFLEX;
            if (oldPT != pt && oldPT != PT_ASSIGN){
                r *= 4;
                dr = -.3;
            }
        }
    }

    void setContainsKernel(){
        if ((pt == PT_REFLEX || pt == PT_CONVEX || pt == PT_ASSIGN)
            && left != null && right != null){
            containsKernel =
               rightTurn(kernel, left, this)  &&
               rightTurn(kernel, this, right) &&
               rightTurn(kernel, right, left);
        }
    }

    void addLinkTo(Point other){
        if (this != other){
            int lt = -1;
            if (pt == PT_KERNEL || other.pt == PT_KERNEL){
                lt = LT_KERNEL;
            }else{
                lt = LT_CURRENT;
            }
            Link link = new Link(this, other, lt);
            this.addLink(link);
            other.addLink(link);
        }
    }

    void addLink(Link link){
        if (links.indexOf(link) == -1){
            links.add(link);
        }
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
        left = right = null;
    }

    void setToGone(){
        pt = PT_GONE;
        for (Link link : links){
            link.lt = LT_GONE;
        }
    }

    void setAsKernel(){
        pt = PT_KERNEL;
        for (Link link : links){
            link.lt = LT_KERNEL;
        }
    }

    void setToFinal(){
        pt = PT_FINAL;
        for (Link link : links){
            if (link.lt != LT_GONE){
                link.lt = LT_FINAL;
            }
        }
        left = right = null;
        containsKernel = false;
    }


    void drawLinks(){
        for (Link link : links){
            link.draw();
        }
    }

    void draw(){
        r += dr;
        if (r < R){
            r = R;
            dr = 0;
        }
        switch(pt){
            case PT_KERNEL:
                fill(KERNELFILL);
                break;
            case PT_OLD:
                fill(#888888);
                break;
            case PT_CONVEX:
                fill(CONVEXFILL);
                break;
            case PT_REFLEX:
                fill(REFLEXFILL);
                break;
            case PT_ASSIGN:
            case PT_FINAL:
                fill(#000000);
                break;
            case PT_GONE:
                return;
            default:
                fill(#FFFF00);
        }
        if (containsKernel && pt != PT_KERNEL){
            strokeWeight(1);
            stroke(KERNELFILL);
            ellipse(x,y,r+1,r+1);
        }else{
            noStroke();
            ellipse(x,y,r,r);
        }

    }

}

