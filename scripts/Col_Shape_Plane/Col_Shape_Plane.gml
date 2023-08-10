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
        return (self.distance == plane.distance) || (cross.x != 0 && cross.y != 0 && cross.z != 0);
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
        var rd = ray.direction;
        var n = self.normal;
        var DdotN = dot_product_3d(rd.x, rd.y, rd.z, n.x, n.y, n.z);
        if (DdotN >= 0) return false;
        
        var ro = ray.origin;
        var OdotN = dot_product_3d(ro.x, ro.y, ro.z, n.x, n.y, n.z);
        var t = (self.distance - OdotN) / DdotN;
        if (t < 0) return false;
        
        var contact_point = ro.Add(rd.Mul(t));
        
        hit_info.Update(t, self, contact_point, n);
        
        return true;
    };
    
    static CheckLine = function(line) {
        var n = self.normal;
        var start = line.start;
        var dir = line.property_ray.direction;
        var NdotS = dot_product_3d(n.x, n.y, n.z, start.x, start.y, start.z);
        var NdotD = dot_product_3d(n.x, n.y, n.z, dir.x, dir.y, dir.z);
        
        if (NdotD == 0) return false;
        var t = (self.distance - NdotS) / NdotD;
        return (t >= 0) && (t <= 1);
    };
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        var nearest = self.NearestPoint(sphere.position);
        var offset = self.normal.Mul(sphere.radius);
        
        return nearest.Add(offset);
    };
    
    static NearestPoint = function(vec3) {
        var n = self.normal;
        var dist = dot_product_3d(n.x, n.y, n.z, vec3.x, vec3.y, vec3.z) - self.distance;
        var scaled_dist = n.Mul(dist);
        return vec3.Sub(scaled_dist);
    };
    
    static PlaneEquation = function(vec3) {
        // much like the dot product, this function will return:
        // - +1ish if the value is in front of the plane
        // - 0 if the value is on the plane
        // - -1ish is the value is behind the plane
        var n = self.normal;
        return dot_product_3d(n.x, n.y, n.z, vec3.x, vec3.y, vec3.z) - self.distance;
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