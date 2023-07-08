function ColPoint(position) constructor {
    self.position = position;               // Vec3
    
    static CheckObject = function(object) {
        return object.shape.CheckPoint(self);
    };
    
    static CheckPoint = function(point) {
        return self.position.Equals(point.position);
    };
    
    static CheckSphere = function(sphere) {
        return self.position.DistanceTo(sphere.position) <= sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        var box_min = aabb.GetMin();
        var box_max = aabb.GetMax();
        if (self.position.x < box_min.x || self.position.y < box_min.y || self.position.z < box_min.z) return false;
        if (self.position.x > box_max.x || self.position.y > box_max.y || self.position.z > box_max.z) return false;
        return true;
    };
    
    static CheckPlane = function(plane) {
        var ndot = self.position.Dot(plane.normal);
        return (ndot == plane.distance);
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckPoint(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckPoint(self);
    };
    
    static CheckTriangle = function(triangle) {
        var pa = triangle.a.Sub(self.position);
        var pb = triangle.b.Sub(self.position);
        var pc = triangle.c.Sub(self.position);
        
        var normPBC = pb.Cross(pc).Normalize();
        var normPCA = pc.Cross(pa).Normalize();
        var normPAB = pa.Cross(pb).Normalize();
        
        if (normPBC.Dot(normPCA) < 1) {
            return false;
        }
        
        if (normPBC.Dot(normPAB) < 1) {
            return false;
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckPoint(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckPoint(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var nearest = ray.NearestPoint(self.position);
        if (nearest.DistanceTo(self.position) != 0) return false;
        
        hit_info.Update(self.position.DistanceTo(ray.origin), self, self.position, undefined);
        
        return true;
    };
    
    static CheckLine = function(line) {
        var nearest = line.NearestPoint(self.position);
         return (nearest.DistanceTo(self.position) == 0);
    };
    
    static GetMin = function() {
        return self.position;
    };
    
    static GetMax = function() {
        return self.position;
    };
    
    static CheckFrustum = function(frustum) {
        var planes = frustum.AsArray();
        for (var i = 0, n = array_length(planes); i < n; i++) {
            var dist = planes[i].normal.Dot(self.position) + planes[i].distance;
            if (dist < 0)
                return EFrustumResults.OUTSIDE;
        }
        return EFrustumResults.INSIDE;
    };
}