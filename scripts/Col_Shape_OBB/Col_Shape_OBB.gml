function ColOBB(position, size, orientation) constructor {
    self.position = position;               // Vec3
    self.size = size;                       // Vec3
    self.orientation = orientation;         // mat4
    
    static CheckObject = function(object) {
        return object.shape.CheckOBB(self);
    };
    
    static CheckPoint = function(point) {
        var dir = point.position.Sub(self.position);
        
        var size_array = self.size.AsLinearArray();
        var orientation_array = self.orientation.AsVectorArray();
        
        for (var i = 0; i < 3; i++) {
            var axis = orientation_array[i];
            
            var dist = dir.Dot(axis);
            
            if (abs(dist) > abs(size_array[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckSphere = function(sphere) {
        
    };
    
    static CheckAABB = function(aabb) {
        
    };
    
    static CheckPlane = function(plane) {
        
    };
    
    static CheckOBB = function(obb) {
        
    };
    
    static CheckCapsule = function(capsule) {
        
    };
    
    static CheckTriangle = function(triangle) {
        
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckOBB(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        
    };
    
    static CheckLine = function(line) {
        
    };
    
    static NearestPoint = function(vec3) {
        
    };
    
    static GetInterval = function(axis) {
        
    };
}