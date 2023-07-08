function ColPlane(normal, distance) constructor {
    self.normal = normal;                   // Vec3
    self.distance = distance;               // number
    
    static CheckObject = function(object) {
        return object.shape.CheckPlane(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckPlane(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckPlane(self);
    };
    
    static CheckAABB = function(aabb) {
        return aabb.CheckPlane(self);
    };
    
    static CheckPlane = function(plane) {
        var cross = self.normal.Cross(plane.normal);
        return (cross.Magnitude() > 0) || (self.distance == plane.distance);
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckPlane(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckPlane(self);
    };
    
    static CheckTriangle = function(triangle) {
        var side_a = self.PlaneEquation(triangle.a);
        var side_b = self.PlaneEquation(triangle.b);
        var side_c = self.PlaneEquation(triangle.c);
        
        if (side_a == 0 && side_b == 0 && side_c == 0) {
            return true;
        }
        
        if (sign(side_a) == sign(side_b) && sign(side_a) == sign(side_c)) {
            return false;
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckPlane(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckPlane(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var DdotN = ray.direction.Dot(self.normal);
        if (DdotN >= 0) return false;
        
        var OdotN = ray.origin.Dot(self.normal);
        var t = (self.distance - OdotN) / DdotN;
        if (t < 0) return false;
        
        var contact_point = ray.origin.Add(ray.direction.Mul(t));
        
        hit_info.Update(t, self, contact_point, self.normal);
        
        return true;
    };
    
    static CheckLine = function(line) {
        var dir = line.finish.Sub(line.start);
        var NdotS = self.normal.Dot(line.start);
        var NdotD = self.normal.Dot(dir);
        
        if (NdotD == 0) return false;
        var t = (self.distance - NdotS) / NdotD;
        return (t >= 0) && (t <= 1);
    };
    
    static NearestPoint = function(vec3) {
        var ndot = self.normal.Dot(vec3);
        var dist = ndot - self.distance;
        var scaled_dist = self.normal.Mul(dist);
        return vec3.Sub(scaled_dist);
    };
    
    static PlaneEquation = function(vec3) {
        // much like the dot product, this function will return:
        // - +1ish if the value is in front of the plane
        // - 0 if the value is on the plane
        // - -1ish is the value is behind the plane
        var dot = vec3.Dot(self.normal);
        return dot - self.distance;
    };
    
    static GetMin = function() {
        return undefined;
    };
    
    static GetMax = function() {
        return undefined;
    };
    
    static Normalize = function() {
        var mag = self.normal.Magnitude();
        return new ColPlane(self.normal.Div(mag), self.distance / mag);
    };
}