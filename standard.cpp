const int _step = 2;

int main() {
    while(not interrupted) {
        point pLeft  = getProbe(0);
        point pRight = getProbe(1); 
        point dest;
        dest.x = (pLeft.x + pRight.x) / 2;
        dest.y = (pLeft.y + pRight.y) / 2;
        pointTo(dest);
    }

}

point getProbe(int isRight) {
    int diff = 1;
    if(isRight) diff = -1;
    int angle = botAngle + diff * 45;
    point curr = botPos;
    int i = 1;
    while(inStream(curr)) {
        curr.x += i * cos(angle);
        curr.y += i * sin(angle);
        i += _step;
    }
    return curr;
}
