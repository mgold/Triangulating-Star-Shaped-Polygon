final int LT_KERNEL = 0;
final int LT_OLD = 1;
final int LT_POLYGON = 2;
final int LT_CURRENT = 3;
final int LT_GONE = 4;

class Link {
    float ax, ay, bx, by;
    int lt;

    Link(float _ax, float _ay, float _bx, float _by, int _lt){
        ax = _ax;
        ay = _ay;
        bx = _bx;
        by = _by;
        lt = _lt;
    }

    void draw(){
        switch(lt){
            case LT_KERNEL:
                stroke(#FF8888);
                break;
            case LT_OLD:
                stroke(#888888);
                break;
            case LT_POLYGON:
                stroke(#000000);
                break;
            case LT_CURRENT:
                stroke(#8888FF);
                break;
            case LT_GONE:
                return;
            default:
                stroke(#FFFF00);
        }
        line(ax, ay, bx, by);
    }

}
