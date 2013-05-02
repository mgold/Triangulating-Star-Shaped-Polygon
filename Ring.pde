class Ring {
    float x, y, ri, ro;

    Ring(){
        x = KERNELX;
        y = KERNELY;
        ri = 180;
        ro = 190;
    }

    void draw(){
        stroke(#00FF00);
        noFill();
        strokeWeight(2);
        ellipse(x, y, ri*2, ri*2);
        for (Point p : convexPoints){
            float xi = -ri*cos(p.angle) + x;
            float yi = ri*sin(-1*p.angle) + y;
            float xf = -ro*cos(p.angle) + x;
            float yf = ro*sin(-1*p.angle) + y;
            line(xi, yi, xf, yf);
        }
    }

}
