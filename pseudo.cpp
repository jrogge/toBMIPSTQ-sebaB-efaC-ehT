int determine_quadrant() {
    if (x >= 150) {
        if (y >= 150) {
            return 1;
        } else {
            return 4;
        }
    } else {
        if (y >= 150) {
            return 2;
        } else {
            return 3;
        }
    }
}

void pointAt(x, y) {
    int deltaX = ship.x - x;
    int deltaY = ship.y - y;
    double angle = tan(deltaY, deltaX);
    setAngle(angle);
}

/*
 * returns the value of the position (x, y)
 * i.e. whether it's a black hole, jetstream, regular space point, etc
 * Do bananas and starcoins show up in jetstream map?
 */
int getPos(int x, int y) {
    return jetstream_map[y][x];
}

/*
 * points spimbot at next coordinate
 */
void nextPoint() {
    int quad = getQuad();
    if (quad == 1) {
        // if point to left (x - 1, y) is in jetstream, point at it
        if (getPos(x-1, y) == 2) {
            pointAt(x-1, y);
            return;
        // elseif point to lower left (x - 1, y + 1)is in jetstream, point at it
        } else if (getPos(x-1, y + 1) == 2) {
            pointAt(x - 1, y + 1);
            return;
        // else point to down (x, y + 1)
        } else if (getPos(x, y + 1) == 2) {
            pointAt(x, y + 1);
            return;
        } else {
            // if we get here, we're not in the jetstream. Implement for robustness?
        }
    } else if (quad == 2) {
        // if point to left (x - 1, y) is in jetstream, point at it
        if (getPos(x-1, y) == 2) {
            pointAt(x-1, y);
            return;
        // elseif point to lower left (x - 1, y + 1)is in jetstream, point at it
        } else if (getPos(x-1, y + 1) == 2) {
            pointAt(x - 1, y + 1);
            return;
        // else point to down (x, y + 1)
        } else if (getPos(x, y + 1) == 2) {
            pointAt(x, y + 1);
            return;
        } else {
            // if we get here, we're not in the jetstream. Implement for robustness?
        }
        // if point to left (x - 1, y) is in jetstream, point at it
        // elseif point to lower left (x - 1, y - 1)is in jetstream, point at it
        // else point to down (x, y - 1)
    } else if (quad == 1) {
        // if point to left (x - 1, y) is in jetstream, point at it
        // elseif point to lower left (x - 1, y - 1)is in jetstream, point at it
        // else point to down (x, y - 1)
    }
    if (quad == 1) {
        // if point to left (x - 1, y) is in jetstream, point at it
        // elseif point to lower left (x - 1, y - 1)is in jetstream, point at it
        // else point to down (x, y - 1)
    }
