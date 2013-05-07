class Ring {
    float x, y, r;
    boolean enabled;

    Ring(){
        x = KERNELX;
        y = KERNELY;
        r = 180;
        enabled = false;
    }

    void enable(){
        enabled = true;
    }

    void disable(){
        enabled = false;
    }

    void draw(){
        if (enabled){
            stroke(#8888FF);
            noFill();
            strokeWeight(2);
            ellipse(x, y, r*2, r*2);
            noStroke();
            for (Point p : convexPoints){
                fill(#00FF00);
                ellipse(p.rx, p.ry, p.r, p.r);
                if (p.containsKernel){
                    fill(#FF0000);
                    ellipse(p.rx,p.ry, 2, 2);
                }
            }
        }
    }

}
