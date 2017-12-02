int getQuad() {
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

void nextPoint() {
    int quad = getQuad();
    if (quad == 1) {
        // if point to left (x - 1, y) is in jetstream, point at it
        // elseif point to lower left (x - 1, y + 1)is in jetstream, point at it
        // else point to down (x, y + 1)
    } else if (quad == 2) {
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
