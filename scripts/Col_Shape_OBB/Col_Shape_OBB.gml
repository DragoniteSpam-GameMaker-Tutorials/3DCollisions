function ColOBB(position, size, orientation) constructor {
    self.position = position;               // Vec3
    self.size = size;                       // Vec3
    self.orientation = orientation;         // mat4
    
    static CheckObject = function(object) {
        return object.shape.CheckOBB(self);
    };
    
    static CheckPoint = function(point) {
        
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