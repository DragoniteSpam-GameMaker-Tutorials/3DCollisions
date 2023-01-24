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
    shape_1 = new ColTestMesh(tree, tree_vertices);
}
if (keyboard_check(vk_numpad7)) {
    shape_1 = new ColTestOBB(obb);
}
if (keyboard_check(vk_numpad8)) {
    shape_1 = new ColTestCapsule(capsule_end, capsule_middle);
}
if (keyboard_check(vk_numpad9)) {
    shape_1 = new ColTestModel(tree, tree_vertices);
}

if (keyboard_check(ord("1"))) {
    shape_2 = new ColTestPoint(point);
}
if (keyboard_check(ord("2"))) {
    shape_2 = new ColTestSphere(sphere);
}
if (keyboard_check(ord("3"))) {
    shape_2 = new ColTestAABB(aabb);
}
if (keyboard_check(ord("4"))) {
    shape_2 = new ColTestTriangle();
}
if (keyboard_check(ord("5"))) {
    shape_2 = new ColTestPlane(plane);
}
if (keyboard_check(ord("6"))) {
    shape_2 = new ColTestLine(undefined);
}
if (keyboard_check(ord("7"))) {
    shape_2 = new ColTestMesh(tree, tree_vertices);
}
if (keyboard_check(ord("8"))) {
    shape_2 = new ColTestOBB(obb);
}
if (keyboard_check(ord("9"))) {
    shape_2 = new ColTestCapsule(capsule_end, capsule_middle);
}
if (keyboard_check(ord("0"))) {
    shape_2 = new ColTestModel(tree, tree_vertices);
}

shape_1.update();