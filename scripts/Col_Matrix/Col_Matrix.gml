function Matrix3(x1_or_array, y1, z1, x2, y2, z2, x3, y3, z3) constructor {
    if (is_array(x1_or_array)) {
        var m = x1_or_array;
        self.x = new Vector3(m[0], m[3], m[6]);
        self.y = new Vector3(m[1], m[4], m[7]);
        self.z = new Vector3(m[2], m[5], m[8]);
    } else {
        var x1 = x1_or_array;
        self.x = new Vector3(x1, x2, x3);
        self.y = new Vector3(y1, y2, y3);
        self.z = new Vector3(z1, z2, z3);
    }
    
    //  x  y  z
    // x1 y1 z1
    // x2 y2 z2
    // x3 y3 z3
    
    static AsLinearArray = function() {
        return [
            self.x.x, self.y.x, self.z.x,
            self.x.y, self.y.y, self.z.y,
            self.x.z, self.y.z, self.z.z
        ];
    };
    
    static AsVectorArray = function() {
        return [self.x, self.y, self.z];
    };
    
    static GetRotationMatrix = function() {
        return new Matrix4(
            self.x.x, self.x.y, self.x.z, 0,
            self.y.x, self.y.y, self.y.z, 0,
            self.z.x, self.z.y, self.z.z, 0,
            0,        0,        0,        1
        );
    };
}

function Matrix4(x1_or_array, y1, z1, w1, x2, y2, z2, w2, x3, y3, z3, w3, x4, y4, z4, w4) constructor {
    if (is_array(x1_or_array)) {
        var m = x1_or_array;
        self.x = new Vector4(m[ 0], m[ 4], m[ 8], m[12]);
        self.y = new Vector4(m[ 1], m[ 5], m[ 9], m[13]);
        self.z = new Vector4(m[ 2], m[ 6], m[10], m[14]);
        self.w = new Vector4(m[ 3], m[ 7], m[11], m[15]);
    } else {
        var x1 = x1_or_array;
        self.x = new Vector4(x1, x2, x3, x4);
        self.y = new Vector4(y1, y2, y3, y4);
        self.z = new Vector4(z1, z2, z3, z4);
        self.w = new Vector4(w1, w2, w3, w4);
    }
    
    //  x  y  z  w
    // x1 y1 z1 w1
    // x2 y2 z2 w2
    // x3 y3 z3 w3
    // x4 y4 z4 w4
    
    static AsLinearArray = function() {
        return [
            self.x.x, self.y.x, self.z.x, self.w.x,
            self.x.y, self.y.y, self.z.y, self.w.y,
            self.x.z, self.y.z, self.z.z, self.w.z,
            self.x.w, self.y.w, self.z.w, self.w.w
        ];
    };
    
    static AsVectorArray = function() {
        return [self.x, self.y, self.z, self.w];
    };
    
    static GetOrientationMatrix = function() {
        return new Matrix3(
            self.x.x, self.y.x, self.z.x,
            self.x.y, self.y.y, self.z.y,
            self.x.z, self.y.z, self.z.z
        );
    };
}