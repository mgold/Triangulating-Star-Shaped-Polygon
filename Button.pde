class Button{
    String label;
    float x, y, w, h;
    boolean enabled;
    color fc, sc, tc;

    Button(float _x, float _y){
        x = _x;
        y = _y;
        w = 80;
        h = 30;
        enabled = false;
        label = null;
        sc = fc = #AAAAAA;
        tc = #000000;
    }

    void draw(){
        if (enabled){
            textSize(.7*h);
            strokeWeight(1);
            fill(fc);
            stroke(sc);
            rect(x,y,w,h);
            fill(tc);
            textAlign(CENTER, CENTER);
            text(label, x+w/2, y+h/2);
            textAlign(LEFT, TOP);
        }
    }

    void disable(){
        enabled = false;
    }

    void enableWithLabel(String l){
        enabled = (l != null);
        label = l;
    }

    void setStroke(color _sc){
        sc = _sc;
    }

    boolean pressed(){
        return (enabled       &&
                mouseX >= x   &&
                mouseX <= x+w &&
                mouseY >= y   &&
                mouseY <= y+h );
    }

}
