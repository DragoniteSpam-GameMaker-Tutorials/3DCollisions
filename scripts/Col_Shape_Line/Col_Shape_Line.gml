function ColLine(start, finish) constructor {
    self.start = start;                     // Vec3
    self.finish = finish;                   // Vec3
    
    static CheckObject = function(object) {
        return object.shape.CheckLine(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckLine(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckLine(self);
    };
    
    static CheckAABB = function(aabb) {
        return aabb.CheckLine(self);
    };
    
    static CheckPlane = function(plane) {
        return plane.CheckLine(self);
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckLine(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckLine(self);
    };
    
    static CheckTriangle = function(triangle) {
        return triangle.CheckLine(self);
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckLine(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        return false;
    };
    
    static CheckLine = function(line) {
        return false;
    };
    
    static Length = function() {
        return self.start.DistanceTo(self.finish);
    };
    
    static NearestPoint = function(vec3) {
        var line_vec = self.finish.Sub(self.start);
        var point_vec = vec3.Sub(self.start);
        var t = clamp(point_vec.Dot(line_vec) / line_vec.Dot(line_vec), 0, 1);
        var scaled_vec = line_vec.Mul(t);
        return self.start.Add(scaled_vec);
    };
}