class Ring {
    float x, y, r;
    boolean enabled;

    Ring(){
        x = KERNELX;
        y = KERNELY;
        r = RINGRADIUS;
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
            stroke(CHAINSTROKE);
            noFill();
            strokeWeight(2);
            ellipse(x, y, r*2, r*2);
            noStroke();
            for (Point p : convexPoints){
                fill(CONVEXFILL);
                ellipse(p.rx, p.ry, p.r, p.r);
                if (p.containsKernel){
                    fill(KERNELFILL);
                    ellipse(p.rx,p.ry, 2, 2);
                }
            }
        }
    }

}
