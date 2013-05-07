final int BEGIN   = 0;
final int ASSIGN1 = 1;
final int ASSIGN2 = 2;
final int ASSIGN3 = 3;
final int SORT1   = 4;
final int SORT2   = 5;
final int CONVEX1 = 6;
final int CONVEX2 = 7;
final int CCHAIN  = 8;
final int ACHAIN  = 9;
final int RAYS    = 10;
final int SELECTED1=11;
final int SELECTED2=12;
final int SETUP   = 13;
final int PAUSE   = 14;
final int FLIP    = 15;
final int FINALIZE= 16;
final int FINAL   = 17;

class State{
    int state;
    long timer;

    State(){
        state = 0;
    }

    void next(){
        state++;
        timer = 0;
    }

    void tick(){
        timer++;
    }
}
