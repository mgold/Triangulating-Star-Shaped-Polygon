final int PT_KERNEL = 0;
final int PT_OLD = 1;
final int PT_CONVEX = 2;
final int PT_REFLEX = 3;
final int PT_ASSIGN = 4;
final int PT_GONE = 5;
final int PT_FINAL = 6;

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
    boolean containsKernel;

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
        containsKernel = pt == PT_KERNEL ? true : false;
    }

    int compareTo(Point other){
        return int(10000*(angle - other.angle));
    }

    void setConvex(){
        if ((pt == PT_REFLEX || pt == PT_CONVEX || pt == PT_ASSIGN)
            && left != null && right != null){
            pt =  rightTurn(left, this, right) ? PT_CONVEX : PT_REFLEX;
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
        left = right = null;
    }

    void setToGone(){
        pt = PT_GONE;
        for (Link link : links){
            link.lt = LT_GONE;
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
            case PT_FINAL:
                fill(#000000);
                break;
            case PT_GONE:
                return;
            default:
                fill(#FFFF00);
        }
        ellipse(x,y,r,r);
        if (containsKernel){
            fill(#FF0000);
            ellipse(x,y, 2, 2);
        }

        float dx = mouseX -x;
        float dy = mouseY -y;
        if (dx*dx + dy*dy < r*r){
            if (left != null && right != null) {
                strokeWeight(2);
                stroke(#FF0000);
                line(x, y, left.x, left.y);
                stroke(#00FF00);
                line(x, y, right.x, right.y);
            }
        }

    }//end of draw()

}//end of class

