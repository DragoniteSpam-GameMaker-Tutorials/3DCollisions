function ColSphere(position, radius) constructor {
    self.position = position;               // Vec3
    self.radius = radius;                   // Vec3
    
    static SetPosition = function(position) {
        self.position = position;
        self.RecalculateProperties();
        return self;
    };
    
    static SetRadius = function(radius) {
        self.radius = radius;
        self.RecalculateProperties();
        return self;
    };
    
    static RecalculateProperties = function() {
        self.property_min = self.position.Sub(self.radius);
        self.property_max = self.position.Add(self.radius);
    };
    
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
        var distance = aabb.position.DistanceTo(self.position);
        var aabb_radius = aabb.half_extents.Magnitude();
        
        if (distance > aabb_radius + self.radius) return false;
        
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
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        if (self.position.DistanceTo(sphere.position) == 0) return undefined;
        
        var dir = sphere.position.Sub(self.position).Normalize();
        var offset = dir.Mul(sphere.radius + self.radius);
        
        return self.position.Add(offset);
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
        var r = self.radius;
        var p = self.position;
        var i = 0;
        repeat (array_length(planes)) {
            var plane = planes[i++];
            var dist = dot_product_3d(plane.normal.x, plane.normal.y, plane.normal.z, p.x, p.y, p.z) + plane.distance;
            
            if (dist < -r)
                return EFrustumResults.OUTSIDE;
            
            if (abs(dist) < r)
                is_intersecting_anything = true;
        }
        return is_intersecting_anything ? EFrustumResults.INTERSECTING : EFrustumResults.INSIDE;
    };
}