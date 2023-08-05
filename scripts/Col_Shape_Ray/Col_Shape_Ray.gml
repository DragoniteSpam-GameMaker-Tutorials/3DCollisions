function ColRay(origin, direction) constructor {
    self.origin = origin;                   // Vec3
    self.direction = direction.Normalize(); // Vec3
    
    static CheckPoint = function(point, hit_info) {
        return point.CheckRay(self, hit_info);
    };
    
    static CheckSphere = function(sphere, hit_info) {
        return sphere.CheckRay(self, hit_info);
    };
    
    static CheckAABB = function(aabb, hit_info) {
        return aabb.CheckRay(self, hit_info);
    };
    
    static CheckPlane = function(plane, hit_info) {
        return plane.CheckRay(self, hit_info);
    };
    
    static CheckOBB = function(obb, hit_info) {
        return obb.CheckRay(self, hit_info);
    };
    
    static CheckCapsule = function(capsule, hit_info) {
        return capsule.CheckRay(self, hit_info);
    };
    
    static CheckTriangle = function(triangle, hit_info) {
        return triangle.CheckRay(self, hit_info);
    };
    
    static CheckMesh = function(mesh, hit_info) {
        return mesh.CheckRay(self, hit_info);
    };
    
    static CheckModel = function(model, hit_info) {
        return model.CheckRay(self, hit_info);
    };
    
    static CheckRay = function(ray, hit_info) {
        return false;
    };
    
    static CheckLine = function(line, hit_info) {
        return false;
    };
    
    static DisplaceSphere = function(sphere) {
        return undefined;
    };
    
    static NearestPoint = function(vec3) {
        var diff = vec3.Sub(self.origin);
        var vx = self.origin.x - vec3.x;
        var vy = self.origin.y - vec3.y;
        var vz = self.origin.z - vec3.z;
        var t = max(dot_product_3d(vx, vy, vz, self.direction.x, self.direction.y, self.direction.z), 0);
        var scaled_dir = self.direction.Mul(t);
        return self.origin.Add(scaled_dir);
    };
    
    static GetMin = function() {
        return undefined;
    };
    
    static GetMax = function() {
        return undefined;
    };
}