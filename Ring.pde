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
            noStroke();
            for (Point p : convexPoints){
                fill(#00FF00);
                float px = -r*cos(   p.angle) + x;
                float py =  r*sin(-1*p.angle) + y;
                ellipse(px, py, 5, 5);
                if (p.containsKernel){
                    fill(#FF0000);
                    ellipse(px,py, 2, 2);
                }
            }
        }
    }

}
