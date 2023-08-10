function ColPoint(position) constructor {
    self.position = position;               // Vec3
    
    self.SetPosition = function(position) {
        self.position = position;
        return self;
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckPoint(self);
    };
    
    static CheckPoint = function(point) {
        var p1 = self.position;
        var p2 = point.position;
        return p1.x == p2.x && p1.y == p2.y && p1.z == p2.z;
    };
    
    static CheckSphere = function(sphere) {
        var pp = self.position;
        var ps = sphere.position;
        return point_distance_3d(pp.x, pp.y, pp.z, ps.x, ps.y, ps.z) < sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        var box_min = aabb.property_min;
        var box_max = aabb.property_max;
        var p = self.position;
        if (p.x < box_min.x || p.y < box_min.y || p.z < box_min.z) return false;
        if (p.x > box_max.x || p.y > box_max.y || p.z > box_max.z) return false;
        return true;
    };
    
    static CheckPlane = function(plane) {
        var p = self.position;
        var n = plane.normal;
        return (dot_product_3d(p.x, p.y, p.z, n.x, n.y, n.z) == plane.distance);
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
        var dist = point_distance_3d(nearest.x, nearest.y, nearest.z, self.position.x, self.position.y, self.position.z);
        if (dist > 0) return false;
        
        dist = point_distance_3d(self.position.x, self.position.y, self.position.z, ray.origin.x, ray.origin.x, ray.origin.z);
        hit_info.Update(dist, self, self.position, undefined);
        
        return true;
    };
    
    static CheckLine = function(line) {
        var nearest = line.NearestPoint(self.position);
        var dist = point_distance_3d(nearest.x, nearest.y, nearest.z, self.position.x, self.position.y, self.position.z);
         return (dist == 0);
    };
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        if (self.position.Equals(sphere.position)) return undefined;
        
        var dir = sphere.position.Sub(self.position).Normalize();
        var offset = dir.Mul(sphere.radius);
        
        return self.position.Add(offset);
    };
    
    static GetMin = function() {
        return self.position;
    };
    
    static GetMax = function() {
        return self.position;
    };
    
    static CheckFrustum = function(frustum) {
        var planes = frustum.AsArray();
        var i = 0;
        repeat (array_length(planes)) {
            var plane = planes[i];
            var dist = plane.normal.Dot(self.position) + plane.distance;
            i++;
            if (dist < 0)
                return EFrustumResults.OUTSIDE;
        }
        return EFrustumResults.INSIDE;
    };
}