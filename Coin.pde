class Coin{
    float r;

    Coin(){
        r = 10;
    }

    void next(){
        try{
            from = to;
            int oldIndex = convexPoints.indexOf(from);
            to = convexPoints.get((oldIndex+1)%convexPoints.size());
        }catch (NullPointerException e){
            this.disable();
        }
    }

    void disable(){
        from = to = null;
    }


    void draw(float frac){
        if (from != null && to != null){
            bound(0.0, frac, 1.0);
            float scale = sin(frac*HALF_PI);
            float dx = to.x - from.x;
            float dy = to.y - from.y;
            float x = from.x + scale*dx;
            float y = from.y + scale*dy;
            noFill();
            strokeWeight(2);
            stroke(COINSTROKE);
            ellipse(x,y,r,r);
            float dtheta = (to.angle - from.angle + TWO_PI) % TWO_PI;
            float theta = (from.angle + dtheta*scale);
            x = -ring.r*cos(   theta) + KERNELX;
            y =  ring.r*sin(-1*theta) + KERNELY;
            ellipse(x,y,r,r);
        }
    }

}

