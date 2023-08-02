function ColSphere(position, radius) constructor {
    self.position = position;               // Vec3
    self.radius = radius;                   // Vec3
    
    static CheckObject = function(object) {
        return object.shape.CheckSphere(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckSphere(self);
    };
    
    static CheckSphere = function(sphere) {
        return self.position.DistanceTo(sphere.position) < (self.radius + sphere.radius);
    };
    
    static CheckAABB = function(aabb) {
        var nearest = aabb.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist < self.radius;
    };
    
    static CheckPlane = function(plane) {
        var nearest = plane.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist < self.radius;
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckSphere(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckSphere(self);
    };
    
    static CheckTriangle = function(triangle) {
        var nearest = triangle.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist < self.radius;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckSphere(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckSphere(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var e = self.position.Sub(ray.origin);
        var mag_squared = power(e.Magnitude(), 2);
        var r_squared = power(self.radius, 2);
        var EdotD = e.Dot(ray.direction);
        var offset = r_squared - (mag_squared - (EdotD * EdotD));
        if (offset < 0) return false;
        
        var f = sqrt(abs(offset));
        var t = EdotD - f;
        if (mag_squared < r_squared) {
            t = EdotD + f;
        }
        var contact_point = ray.origin.Add(ray.direction.Mul(t));
        
        hit_info.Update(t, self, contact_point, contact_point.Sub(self.position).Normalize());
        
        return true;
    };
    
    static CheckLine = function(line) {
        var nearest = line.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist < self.radius;
    };
    
    static NearestPoint = function(vec3) {
        var dist = vec3.Sub(self.position).Normalize();
        var scaled_dist = dist.Mul(self.radius);
        return scaled_dist.Add(self.position);
    };
    
    static GetMin = function() {
        return self.position.Sub(self.radius);
    };
    
    static GetMax = function() {
        return self.position.Add(self.radius);
    };
    
    static CheckFrustum = function(frustum) {
        var planes = frustum.AsArray();
        var is_intersecting_anything = false;
        for (var i = 0, n = array_length(planes); i < n; i++) {
            var dist = planes[i].normal.Dot(self.position) + planes[i].distance;
            if (dist < -self.radius)
                return EFrustumResults.OUTSIDE;
            
            if (abs(dist) < self.radius)
                is_intersecting_anything = true;
        }
        return is_intersecting_anything ? EFrustumResults.INTERSECTING : EFrustumResults.INSIDE;
    };
}