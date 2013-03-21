final int LT_KERNEL = 0;
final int LT_OUTSIDE = 1;
final int LT_POLYGON = 2;
final int LT_CURRENT = 3;

class Link {
    Point a, b;
    int lt;

    Link(Point _a, Point _b, int _lt){
        a = _b;
        b = _b;
        lt = _lt;
    }

    void draw(){
        noFill();
        switch(lt){
            case LT_KERNEL:
                stroke(#FF8888);
                break;
            case LT_OUTSIDE:
                stroke(#888888);
                break;
            case LT_POLYGON:
                stroke(#00FF00);
                break;
            case LT_CURRENT:
                stroke(#8888FF);
                break;
            default:
                stroke(#FFFF00);
        }
        line(a.x,a.y,b.x,b.y);
    }

}
