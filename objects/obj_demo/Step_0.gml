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

if (keyboard_check(vk_numpad0)) {
    shape_1 = new ColTestPoint(point);
}
if (keyboard_check(vk_numpad1)) {
    shape_1 = new ColTestSphere(sphere);
}
if (keyboard_check(vk_numpad2)) {
    shape_1 = new ColTestAABB(aabb);
}
if (keyboard_check(vk_numpad3)) {
    shape_1 = new ColTestTriangle();
}
if (keyboard_check(vk_numpad4)) {
    shape_1 = new ColTestPlane(plane);
}
if (keyboard_check(vk_numpad5)) {
    shape_1 = new ColTestLine(undefined);
}
if (keyboard_check(vk_numpad6)) {
    shape_1 = new ColTestMesh(tree);
}

if (keyboard_check(ord("Z"))) {
    shape_2 = new ColTestPoint(point);
}
if (keyboard_check(ord("X"))) {
    shape_2 = new ColTestSphere(sphere);
}
if (keyboard_check(ord("C"))) {
    shape_2 = new ColTestAABB(aabb);
}
if (keyboard_check(ord("V"))) {
    shape_2 = new ColTestTriangle();
}
if (keyboard_check(ord("B"))) {
    shape_2 = new ColTestPlane(plane);
}
if (keyboard_check(ord("N"))) {
    shape_2 = new ColTestLine(undefined);
}
if (keyboard_check(ord("M"))) {
    shape_2 = new ColTestMesh(tree);
}

shape_1.update();