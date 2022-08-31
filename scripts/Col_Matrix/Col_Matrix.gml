function Matrix3(x1, y1, z1, x2, y2, z2, x3, y3, z3) constructor {
    self.x = new Vector3(x1, x2, x3);
    self.y = new Vector3(y1, y2, y3);
    self.z = new Vector3(z1, z2, z3);
    
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
}

function Matrix4(x1, y1, z1, w1, x2, y2, z2, w2, x3, y3, z3, w3, x4, y4, z4, w4) constructor {
    self.x = new Vector4(x1, x2, x3, x4);
    self.y = new Vector4(y1, y2, y3, y4);
    self.z = new Vector4(z1, z2, z3, z4);
    self.w = new Vector4(w1, w2, w3, w4);
    
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
}