final int BEGIN   = 0;
final int ASSIGN1 = 1;
final int ASSIGN2 = 2;
final int ASSIGN3 = 3;
final int SORT    = 4;
final int FLIP    = 5;
final int FINALIZE= 6;
final int FINAL   = 7;

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
