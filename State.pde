final int ASSIGN1 = 0;
final int ASSIGN2 = 1;
final int ASSIGN3 = 2;
final int ASSIGN4 = 3;
final int SORT    = 4;
final int FLIP    = 5;
final int FINAL   = 6;

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
