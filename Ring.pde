class Ring {
    float x, y, r;
    boolean enabled;

    Ring(){
        x = KERNELX;
        y = KERNELY;
        r = 2*RINGRADIUS;
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
            ellipse(x, y, r, r);
            noStroke();
            fill(CONVEXFILL);
            for (Point p : convexPoints){
                if (p.containsKernel){
                    strokeWeight(1);
                    stroke(KERNELFILL);
                    ellipse(p.rx, p.ry, p.r+1, p.r+1);
                }else{
                    noStroke();
                    ellipse(p.rx, p.ry, p.r, p.r);
                }
            }
        }
    }

}
