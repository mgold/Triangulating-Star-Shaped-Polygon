class Ring {
    float x, y, r;

    Ring(){
        x = KERNELX;
        y = KERNELY;
        r = 180;
    }

    void draw(){
        if (convexPoints.size() > 0){
            stroke(#8888FF);
            noFill();
            strokeWeight(2);
            ellipse(x, y, r*2, r*2);
            fill(#00FF00);
            noStroke();
            for (Point p : convexPoints){
                float _x = -r*cos(   p.angle) + x;
                float _y =  r*sin(-1*p.angle) + y;
                ellipse(_x, _y, 5, 5);
            }
        }
    }

}
