function ColTransformedModel(mesh, position = new Vector3(0, 0, 0), rotation = new Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)) constructor {
    self.mesh = mesh;
    self.position = position;
    self.rotation = rotation;
    
    static GetTransformMatrix = function() {
        return self.rotation.GetRotationMatrix().Mul(self.position.GetTranslationMatrix());
    };
    
    static CheckPoint = function(point) {
        
    };
    
    static CheckSphere = function(sphere) {
        
    };
    
    static CheckAABB = function(aabb) {
        
    };
    
    static CheckOBB = function(obb) {
        
    };
    
    static CheckPlane = function(plane) {
        
    };
    
    static CheckCapsule = function(capsule) {
        
    };
    
    static CheckTriangle = function(triangle) {
        
    };
    
    static CheckMesh = function(mesh) {
        return false;
    };
    
    static CheckModel = function(mesh) {
        return false;
    };
    
    static CheckLine = function(line) {
        
    };
    
    static CheckRay = function(ray, hit_info) {
        
    };
}