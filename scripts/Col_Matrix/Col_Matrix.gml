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
    
    self.rotation_matrix = undefined;
    
    static GetRotationMatrix = function() {
        self.rotation_matrix ??= new Matrix4(
            self.x.x, self.x.y, self.x.z, 0,
            self.y.x, self.y.y, self.y.z, 0,
            self.z.x, self.z.y, self.z.z, 0,
            0,        0,        0,        1
        );
        return self.rotation_matrix;
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
    
    self.orientation_matrix = undefined;
    
    static GetOrientationMatrix = function() {
        self.orientation_matrix ??= new Matrix3(
            self.x.x, self.x.y, self.x.z,
            self.y.x, self.y.y, self.y.z,
            self.z.x, self.z.y, self.z.z
        );
        return self.orientation_matrix;
    };
    
    static Mul = function(mat) {
        return new Matrix4(matrix_multiply(self.linear_array, mat.linear_array));
    };
}

function mat4_inverse(mat) {
    var results = array_create(16);
    results[0]  =  mat[ 5] * mat[10] * mat[15] - mat[ 5] * mat[11] * mat[14] - mat[ 9] * mat[ 6] * mat[15] + mat[ 9] * mat[ 7] * mat[14] + mat[13] * mat[ 6] * mat[11] - mat[13] * mat[ 7] * mat[10];
    results[1]  = -mat[ 1] * mat[10] * mat[15] + mat[ 1] * mat[11] * mat[14] + mat[ 9] * mat[ 2] * mat[15] - mat[ 9] * mat[ 3] * mat[14] - mat[13] * mat[ 2] * mat[11] + mat[13] * mat[ 3] * mat[10];
    results[2]  =  mat[ 1] * mat[ 6] * mat[15] - mat[ 1] * mat[ 7] * mat[14] - mat[ 5] * mat[ 2] * mat[15] + mat[ 5] * mat[ 3] * mat[14] + mat[13] * mat[ 2] * mat[ 7] - mat[13] * mat[ 3] * mat[ 6];
    results[3]  = -mat[ 1] * mat[ 6] * mat[11] + mat[ 1] * mat[ 7] * mat[10] + mat[ 5] * mat[ 2] * mat[11] - mat[ 5] * mat[ 3] * mat[10] - mat[ 9] * mat[ 2] * mat[ 7] + mat[ 9] * mat[ 3] * mat[ 6];
    results[4]  = -mat[ 4] * mat[10] * mat[15] + mat[ 4] * mat[11] * mat[14] + mat[ 8] * mat[ 6] * mat[15] - mat[ 8] * mat[ 7] * mat[14] - mat[12] * mat[ 6] * mat[11] + mat[12] * mat[ 7] * mat[10];
    results[5]  =  mat[ 0] * mat[10] * mat[15] - mat[ 0] * mat[11] * mat[14] - mat[ 8] * mat[ 2] * mat[15] + mat[ 8] * mat[ 3] * mat[14] + mat[12] * mat[ 2] * mat[11] - mat[12] * mat[ 3] * mat[10];
    results[6]  = -mat[ 0] * mat[ 6] * mat[15] + mat[ 0] * mat[ 7] * mat[14] + mat[ 4] * mat[ 2] * mat[15] - mat[ 4] * mat[ 3] * mat[14] - mat[12] * mat[ 2] * mat[ 7] + mat[12] * mat[ 3] * mat[ 6];
    results[7]  =  mat[ 0] * mat[ 6] * mat[11] - mat[ 0] * mat[ 7] * mat[10] - mat[ 4] * mat[ 2] * mat[11] + mat[ 4] * mat[ 3] * mat[10] + mat[ 8] * mat[ 2] * mat[ 7] - mat[ 8] * mat[ 3] * mat[ 6];
    results[8]  =  mat[ 4] * mat[ 9] * mat[15] - mat[ 4] * mat[11] * mat[13] - mat[ 8] * mat[ 5] * mat[15] + mat[ 8] * mat[ 7] * mat[13] + mat[12] * mat[ 5] * mat[11] - mat[12] * mat[ 7] * mat[ 9];
    results[9]  = -mat[ 0] * mat[ 9] * mat[15] + mat[ 0] * mat[11] * mat[13] + mat[ 8] * mat[ 1] * mat[15] - mat[ 8] * mat[ 3] * mat[13] - mat[12] * mat[ 1] * mat[11] + mat[12] * mat[ 3] * mat[ 9];
    results[10] =  mat[ 0] * mat[ 5] * mat[15] - mat[ 0] * mat[ 7] * mat[13] - mat[ 4] * mat[ 1] * mat[15] + mat[ 4] * mat[ 3] * mat[13] + mat[12] * mat[ 1] * mat[ 7] - mat[12] * mat[ 3] * mat[ 5];
    results[11] = -mat[ 0] * mat[ 5] * mat[11] + mat[ 0] * mat[ 7] * mat[ 9] + mat[ 4] * mat[ 1] * mat[11] - mat[ 4] * mat[ 3] * mat[ 9] - mat[ 8] * mat[ 1] * mat[ 7] + mat[ 8] * mat[ 3] * mat[ 5];
    results[12] = -mat[ 4] * mat[ 9] * mat[14] + mat[ 4] * mat[10] * mat[13] + mat[ 8] * mat[ 5] * mat[14] - mat[ 8] * mat[ 6] * mat[13] - mat[12] * mat[ 5] * mat[10] + mat[12] * mat[ 6] * mat[ 9];
    results[13] =  mat[ 0] * mat[ 9] * mat[14] - mat[ 0] * mat[10] * mat[13] - mat[ 8] * mat[ 1] * mat[14] + mat[ 8] * mat[ 2] * mat[13] + mat[12] * mat[ 1] * mat[10] - mat[12] * mat[ 2] * mat[ 9];
    results[14] = -mat[ 0] * mat[ 5] * mat[14] + mat[ 0] * mat[ 6] * mat[13] + mat[ 4] * mat[ 1] * mat[14] - mat[ 4] * mat[ 2] * mat[13] - mat[12] * mat[ 1] * mat[ 6] + mat[12] * mat[ 2] * mat[ 5];
    results[15] =  mat[ 0] * mat[ 5] * mat[10] - mat[ 0] * mat[ 6] * mat[ 9] - mat[ 4] * mat[ 1] * mat[10] + mat[ 4] * mat[ 2] * mat[ 9] + mat[ 8] * mat[ 1] * mat[ 6] - mat[ 8] * mat[ 2] * mat[ 5];
    
    var determinant = mat[0] * results[0] + mat[1] * results[4] + mat[2] * results[8] + mat[3] * results[12];
    
    if (determinant == 0) {
    	return undefined;
    }
    
    var i = 0;
    repeat (16) {
    	results[i++] /= determinant;
    }
    
    return results;
}

function mat4_mul_point(mat, point) {
    var transformed_point = matrix_transform_vertex(mat, point.x, point.y, point.z, 1);
    return new Vector3(transformed_point[0], transformed_point[1], transformed_point[2]);
}

function mat4_mul_vector(mat, vec) {
    var transformed_point = matrix_transform_vertex(mat, vec.x, vec.y, vec.z, 0);
    return new Vector3(transformed_point[0], transformed_point[1], transformed_point[2]);
}