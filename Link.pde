final int LT_KERNEL = 0;
final int LT_OLD = 1;
final int LT_FINAL = 2;
final int LT_CURRENT = 3;
final int LT_GONE = 4;

class Link {
    Point a, b;
    int lt;

    Link(Point _a, Point _b, int _lt){
        a = _a;
        b = _b;
        lt = _lt;
    }

    void draw(){
        strokeWeight(1);
        switch(lt){
            case LT_KERNEL:
                if (shouldDrawKernelRays){
                    stroke(KERNELFILL);
                }else{
                    return;
                }
                break;
            case LT_OLD:
                stroke(#888888);
                break;
            case LT_FINAL:
                stroke(#000000);
                break;
            case LT_CURRENT:
                stroke(#000000);
                break;
            case LT_GONE:
                return;
            default:
                stroke(#FFFF00);
        }
        line(a.x, a.y, b.x, b.y);
    }

}
