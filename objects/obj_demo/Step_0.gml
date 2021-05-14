if (keyboard_check(ord("A"))) {
    dir++;
}
if (keyboard_check(ord("D"))) {
    dir--;
}
if (keyboard_check(ord("W"))) {
    pitch = max(--pitch, -80);
}
if (keyboard_check(ord("S"))) {
    pitch = min(++pitch, 80);
}
if (keyboard_check(ord("Q"))) {
    dist = max(--dist, 20);
}
if (keyboard_check(ord("E"))) {
    dist = min(++dist, 400);
}

shape_1.update();
shape_2.update();