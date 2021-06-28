function screen_to_world(x, y, v, p) {
    /*
        Transforms a 2D coordinate (in window space) to a 3D vector.
        Returns an array of the following format:
        [dx, dy, dz, ox, oy, oz]
        where [dx, dy, dz] is the direction vector and [ox, oy, oz] is the origin of the ray.
        Works for both orthographic and perspective projections.
        Script created by TheSnidr
        (slightly modified by @dragonitespam)
    */
    
    var mx = 2 * (x / window_get_width() - .5) / p[0];
    var my = 2 * (y / window_get_height() - .5) / p[5];
    var camX = - (v[12] * v[0] + v[13] * v[1] + v[14] * v[2]);
    var camY = - (v[12] * v[4] + v[13] * v[5] + v[14] * v[6]);
    var camZ = - (v[12] * v[8] + v[13] * v[9] + v[14] * v[10]);
    
    if (p[15] == 0) {    //This is a perspective projection
        return new Vector3(v[2]  + mx * v[0] + my * v[1], v[6]  + mx * v[4] + my * v[5], v[10] + mx * v[8] + my * v[9]);
    } else {    //This is an ortho projection
        return new Vector3(v[2], v[6], v[10]);
    }
}