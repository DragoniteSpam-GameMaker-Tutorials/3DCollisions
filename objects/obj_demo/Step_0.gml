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
    shape_1 = new ColTestPoint(point, false);
}
if (keyboard_check(vk_numpad1)) {
    shape_1 = new ColTestSphere(sphere, false);
}
if (keyboard_check(vk_numpad2)) {
    shape_1 = new ColTestSphere(aabb, false);
}
if (keyboard_check(vk_numpad3)) {
    shape_1 = new ColTestPlane(plane, false);
}

if (keyboard_check(vk_numpad4)) {
    shape_2 = new ColTestPoint(point, true);
}
if (keyboard_check(vk_numpad5)) {
    shape_2 = new ColTestSphere(sphere, true);
}
if (keyboard_check(vk_numpad6)) {
    shape_2 = new ColTestSphere(aabb, true);
}
if (keyboard_check(vk_numpad7)) {
    shape_2 = new ColTestPlane(plane, true);
}

shape_1.update();
shape_2.update();