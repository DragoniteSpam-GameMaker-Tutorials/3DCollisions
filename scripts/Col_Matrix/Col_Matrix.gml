function Matrix3(x1_or_array, y1, z1, x2, y2, z2, x3, y3, z3) constructor {
    if (is_array(x1_or_array)) {
        var m = x1_or_array;
        self.x = new Vector3(m[0], m[3], m[6]);
        self.y = new Vector3(m[1], m[4], m[7]);
        self.z = new Vector3(m[2], m[5], m[8]);
        
        self.linear_array = x1_or_array;
    } else {
        var x1 = x1_or_array;
        self.x = new Vector3(x1, x2, x3);
        self.y = new Vector3(y1, y2, y3);
        self.z = new Vector3(z1, z2, z3);
    
        self.linear_array = [
            self.x.x, self.y.x, self.z.x,
            self.x.y, self.y.y, self.z.y,
            self.x.z, self.y.z, self.z.z
        ];
    }
    
    //  x  y  z
    // x1 y1 z1
    // x2 y2 z2
    // x3 y3 z3
    
    self.vector_array = [self.x, self.y, self.z];
    
    self.rotation_matrix = undefined;
    
    static AsLinearArray = function() {
        return self.linear_array;
    };
    
    static AsVectorArray = function() {
        return self.vector_array;
    };
    
    static GetRotationMatrix = function() {
        self.rotation_matrix ??= new Matrix4(
            self.x.x, self.x.y, self.x.z, 0,
            self.y.x, self.y.y, self.y.z, 0,
            self.z.x, self.z.y, self.z.z, 0,
            0,        0,        0,        1
        );
        return self.rotation_matrix;
    };
    
    static Mul = function(mat) {
        return self.GetRotationMatrix().Mul(mat.GetRotationMatrix()).GetOrientationMatrix();
    };
    
    static MulVector = function(vec) {
        return self.GetRotationMatrix().MulVector(vec);
    };
}

function Matrix4(x1_or_array, y1, z1, w1, x2, y2, z2, w2, x3, y3, z3, w3, x4, y4, z4, w4) constructor {
    if (is_array(x1_or_array)) {
        var m = x1_or_array;
        self.x = new Vector4(m[ 0], m[ 4], m[ 8], m[12]);
        self.y = new Vector4(m[ 1], m[ 5], m[ 9], m[13]);
        self.z = new Vector4(m[ 2], m[ 6], m[10], m[14]);
        self.w = new Vector4(m[ 3], m[ 7], m[11], m[15]);
        
        self.linear_array = x1_or_array;
    } else {
        var x1 = x1_or_array;
        self.x = new Vector4(x1, x2, x3, x4);
        self.y = new Vector4(y1, y2, y3, y4);
        self.z = new Vector4(z1, z2, z3, z4);
        self.w = new Vector4(w1, w2, w3, w4);
    
        self.linear_array = [
            self.x.x, self.y.x, self.z.x, self.w.x,
            self.x.y, self.y.y, self.z.y, self.w.y,
            self.x.z, self.y.z, self.z.z, self.w.z,
            self.x.w, self.y.w, self.z.w, self.w.w
        ];
    }
    
    //  x  y  z  w
    // x1 y1 z1 w1
    // x2 y2 z2 w2
    // x3 y3 z3 w3
    // x4 y4 z4 w4
    
    self.vector_array = [self.x, self.y, self.z, self.w];
    
    self.orientation_matrix = undefined;
    
    static AsLinearArray = function() {
        return self.linear_array;
    };
    
    static AsVectorArray = function() {
        return self.vector_array;
    };
    
    static GetOrientationMatrix = function() {
        self.orientation_matrix ??= new Matrix3(
            self.x.x, self.y.x, self.z.x,
            self.x.y, self.y.y, self.z.y,
            self.x.z, self.y.z, self.z.z
        );
        return self.orientation_matrix;
    };
    
    static Mul = function(mat) {
        return new Matrix4(matrix_multiply(self.linear_array, mat.linear_array));
    };
    
    static MulPoint = function(point) {
        var transformed_point = matrix_transform_vertex(self.linear_array, point.x, point.y, point.z, 1);
        return new Vector3(transformed_point[0], transformed_point[1], transformed_point[2]);
    };
    
    static MulVector = function(vec) {
        var transformed_point = matrix_transform_vertex(self.linear_array, point.x, point.y, point.z, 0);
        return new Vector3(transformed_point[0], transformed_point[1], transformed_point[2]);
    };
    
    static Inverse = function() {
        var m = self.linear_array;
        
        var results = array_create(16);
    	results[0]  =  m[ 5] * m[10] * m[15] - m[ 5] * m[11] * m[14] - m[ 9] * m[ 6] * m[15] + m[ 9] * m[ 7] * m[14] + m[13] * m[ 6] * m[11] - m[13] * m[ 7] * m[10];
    	results[1]  = -m[ 1] * m[10] * m[15] + m[ 1] * m[11] * m[14] + m[ 9] * m[ 2] * m[15] - m[ 9] * m[ 3] * m[14] - m[13] * m[ 2] * m[11] + m[13] * m[ 3] * m[10];
    	results[2]  =  m[ 1] * m[ 6] * m[15] - m[ 1] * m[ 7] * m[14] - m[ 5] * m[ 2] * m[15] + m[ 5] * m[ 3] * m[14] + m[13] * m[ 2] * m[ 7] - m[13] * m[ 3] * m[ 6];
    	results[3]  = -m[ 1] * m[ 6] * m[11] + m[ 1] * m[ 7] * m[10] + m[ 5] * m[ 2] * m[11] - m[ 5] * m[ 3] * m[10] - m[ 9] * m[ 2] * m[ 7] + m[ 9] * m[ 3] * m[ 6];
    	results[4]  = -m[ 4] * m[10] * m[15] + m[ 4] * m[11] * m[14] + m[ 8] * m[ 6] * m[15] - m[ 8] * m[ 7] * m[14] - m[12] * m[ 6] * m[11] + m[12] * m[ 7] * m[10];
    	results[5]  =  m[ 0] * m[10] * m[15] - m[ 0] * m[11] * m[14] - m[ 8] * m[ 2] * m[15] + m[ 8] * m[ 3] * m[14] + m[12] * m[ 2] * m[11] - m[12] * m[ 3] * m[10];
    	results[6]  = -m[ 0] * m[ 6] * m[15] + m[ 0] * m[ 7] * m[14] + m[ 4] * m[ 2] * m[15] - m[ 4] * m[ 3] * m[14] - m[12] * m[ 2] * m[ 7] + m[12] * m[ 3] * m[ 6];
    	results[7]  =  m[ 0] * m[ 6] * m[11] - m[ 0] * m[ 7] * m[10] - m[ 4] * m[ 2] * m[11] + m[ 4] * m[ 3] * m[10] + m[ 8] * m[ 2] * m[ 7] - m[ 8] * m[ 3] * m[ 6];
    	results[8]  =  m[ 4] * m[ 9] * m[15] - m[ 4] * m[11] * m[13] - m[ 8] * m[ 5] * m[15] + m[ 8] * m[ 7] * m[13] + m[12] * m[ 5] * m[11] - m[12] * m[ 7] * m[ 9];
    	results[9]  = -m[ 0] * m[ 9] * m[15] + m[ 0] * m[11] * m[13] + m[ 8] * m[ 1] * m[15] - m[ 8] * m[ 3] * m[13] - m[12] * m[ 1] * m[11] + m[12] * m[ 3] * m[ 9];
    	results[10] =  m[ 0] * m[ 5] * m[15] - m[ 0] * m[ 7] * m[13] - m[ 4] * m[ 1] * m[15] + m[ 4] * m[ 3] * m[13] + m[12] * m[ 1] * m[ 7] - m[12] * m[ 3] * m[ 5];
    	results[11] = -m[ 0] * m[ 5] * m[11] + m[ 0] * m[ 7] * m[ 9] + m[ 4] * m[ 1] * m[11] - m[ 4] * m[ 3] * m[ 9] - m[ 8] * m[ 1] * m[ 7] + m[ 8] * m[ 3] * m[ 5];
    	results[12] = -m[ 4] * m[ 9] * m[14] + m[ 4] * m[10] * m[13] + m[ 8] * m[ 5] * m[14] - m[ 8] * m[ 6] * m[13] - m[12] * m[ 5] * m[10] + m[12] * m[ 6] * m[ 9];
    	results[13] =  m[ 0] * m[ 9] * m[14] - m[ 0] * m[10] * m[13] - m[ 8] * m[ 1] * m[14] + m[ 8] * m[ 2] * m[13] + m[12] * m[ 1] * m[10] - m[12] * m[ 2] * m[ 9];
    	results[14] = -m[ 0] * m[ 5] * m[14] + m[ 0] * m[ 6] * m[13] + m[ 4] * m[ 1] * m[14] - m[ 4] * m[ 2] * m[13] - m[12] * m[ 1] * m[ 6] + m[12] * m[ 2] * m[ 5];
    	results[15] =  m[ 0] * m[ 5] * m[10] - m[ 0] * m[ 6] * m[ 9] - m[ 4] * m[ 1] * m[10] + m[ 4] * m[ 2] * m[ 9] + m[ 8] * m[ 1] * m[ 6] - m[ 8] * m[ 2] * m[ 5];
        
        var determinant = m[0] * results[0] + m[1] * results[4] + m[2] * results[8] + m[3] * results[12];
        
    	if (determinant == 0) {
    		return undefined;
    	}
        
        var i = 0;
    	repeat (16) {
    		results[i++] /= determinant;
    	}
        
    	return new Matrix4(results);
    };
}