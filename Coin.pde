class Coin{
    Point from, to;
    float r;

    Coin(Point _from){
        from = _from;
        to = from.right;
        r = 10;
    }

    void next(){
        try{
            from = to;
            to = from.right;
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
            to  .selected = frac > .8;
            from.selected = frac < .2;
            float scale = sin(frac*HALF_PI);
            float dx = to.x - from.x;
            float dy = to.y - from.y;
            float x = from.x + scale*dx;
            float y = from.y + scale*dy;
            noFill();
            strokeWeight(2);
            stroke(COINSTROKE);
            ellipse(x,y,r,r);
        }
    }

}

