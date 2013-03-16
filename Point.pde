class Point implements Comparable<Point>{
    float x, y;
    float r;
    int id;
    color fillColor;

    float angle;
    float kernelDist;

    Point(float _x, float _y, int _id){
        x = _x;
        y = _y;
        id = _id;
        r = 5;
        fillColor = #000000;

        angle = atan2(KERNELY-y, KERNELX-x);
        kernelDist = dist(KERNELX, KERNELY, x, y);

    }

    int compareTo(Point other){
        return int(10000*(angle - other.angle));
    }

    void draw(){
        noStroke();
        fill(fillColor);
        ellipse(x,y,r,r);
    }
}
