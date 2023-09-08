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
	
	array_map_ext(results, method({ determinant: determinant }, function(val) {
		return val / self.determinant;
	}));
	
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