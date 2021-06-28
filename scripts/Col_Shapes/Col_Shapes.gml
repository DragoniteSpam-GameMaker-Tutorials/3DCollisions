// Some basic shapes
function ColPoint(position) constructor {
    self.position = position;               // Vec3
    
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
    
    static CheckRay = function(ray, hit_info) {
        var nearest = ray.NearestPoint(self.position);
        if (nearest.DistanceTo(self.position) != 0) return false;
        
        hit_info.Update(self.position.DistanceTo(ray.origin), self, self.position, undefined);
        
        return true;
    };
    
    static CheckLine = function(line) {
        
    };
}

function ColSphere(position, radius) constructor {
    self.position = position;               // Vec3
    self.radius = radius;                   // Vec3
    
    static CheckPoint = function(point) {
        return point.CheckSphere(self);
    };
    
    static CheckSphere = function(sphere) {
        return self.position.DistanceTo(sphere.position) <= (self.radius + sphere.radius);
    };
    
    static CheckAABB = function(aabb) {
        var nearest = aabb.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist <= self.radius;
    };
    
    static CheckPlane = function(plane) {
        var nearest = plane.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist <= self.radius;
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
        
    };
    
    static NearestPoint = function(vec3) {
        var dist = vec3.Sub(self.position).Normalize();
        var scaled_dist = dist.Mul(self.radius);
        return scaled_dist.Add(self.position);
    };
}

function ColAABB(position, half_extents) constructor {
    self.position = position;               // Vec3
    self.half_extents = half_extents;       // Vec3
    
    static CheckPoint = function(point) {
        return point.CheckAABB(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckAABB(self);
    };
    
    static CheckAABB = function(aabb) {
        var box_min = self.GetMin();
        var box_max = self.GetMax();
        var other_min = aabb.GetMin();
        var other_max = aabb.GetMax();
        return ((box_min.x <= other_max.x) && (box_max.x >= other_min.x) && (box_min.y <= other_max.y) && (box_max.y >= other_min.y) && (box_min.z <= other_max.z) && (box_max.z >= other_min.z));
    };
    
    static CheckPlane = function(plane) {
        var anorm = plane.normal.Abs();
        var plength = self.half_extents.Dot(anorm);
        var ndot = plane.normal.Dot(self.position);
        var dist = ndot - plane.distance;
        return (abs(dist) <= plength);
    };
    
    static CheckRay = function(ray, hit_info) {
        var box_min = self.GetMin();
        var box_max = self.GetMax();
        
        var ray_x = (ray.direction.x == 0) ? 0.0001 : ray.direction.x;
        var ray_y = (ray.direction.y == 0) ? 0.0001 : ray.direction.y;
        var ray_z = (ray.direction.z == 0) ? 0.0001 : ray.direction.z;
        
        var t1 = (box_min.x - ray.origin.x) / ray_x;
        var t2 = (box_max.x - ray.origin.x) / ray_x;
        var t3 = (box_min.y - ray.origin.y) / ray_y;
        var t4 = (box_max.y - ray.origin.y) / ray_y;
        var t5 = (box_min.z - ray.origin.z) / ray_z;
        var t6 = (box_max.z - ray.origin.z) / ray_z;
        
        var tmin = max(
            min(t1, t2),
            min(t3, t4),
            min(t5, t6)
        );
        var tmax = min(
            max(t1, t2),
            max(t3, t4),
            max(t5, t6)
        );
        
        if (tmax < 0) return false;
        if (tmin > tmax) return false;
        
        var t = tmax;
        if (tmin > 0) {
            t = tmin;
        }
        
        var contact_point = ray.origin.Add(ray.direction.Mul(t));
        
        hit_info.Update(t, self, contact_point, undefined);
        
        return true;
    };
    
    static CheckLine = function(line) {
        
    };
    
    static GetMin = function() {
        return self.position.Sub(self.half_extents);
    };
    
    static GetMax = function() {
        return self.position.Add(self.half_extents);
    };
    
    static NearestPoint = function(vec3) {
        var box_min = self.GetMin();
        var box_max = self.GetMax();
        var xx = (vec3.x < box_min.x) ? box_min.x : vec3.x;
        var yy = (vec3.y < box_min.y) ? box_min.y : vec3.y;
        var zz = (vec3.z < box_min.z) ? box_min.z : vec3.z;
        xx = (xx > box_max.x) ? box_max.x : xx;
        yy = (yy > box_max.y) ? box_max.y : yy;
        zz = (zz > box_max.z) ? box_max.z : zz;
        return new Vector3(xx, yy, zz);
    };
}

function ColPlane(normal, distance) constructor {
    self.normal = normal.Normalize();       // Vec3
    self.distance = distance;               // number
    
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
    
    static CheckRay = function(ray, hit_info) {
        var DdotN = ray.direction.Dot(self.normal);
        if (DdotN >= 0) return false;
        
        var OdotN = ray.origin.Dot(self.normal);
        var t = (self.distance - OdotN) / DdotN;
        if (t < 0) return false;
        
        var contact_point = ray.origin.Add(ray.direction.Mul(t));
        
        hit_info.Update(t, self, contact_point, undefined);
        
        return true;
    };
    
    static CheckLine = function(line) {
        
    };
    
    static NearestPoint = function(vec3) {
        var ndot = self.normal.Dot(vec3);
        var dist = ndot - self.distance;
        var scaled_dist = self.normal.Mul(dist);
        return vec3.Sub(scaled_dist);
    };
}

// Line "shapes"
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
    
    static CheckRay = function(ray, hit_info) {
        return false;
    };
    
    static CheckLine = function(line, hit_info) {
        return false;
    };
    
    static NearestPoint = function(vec3) {
        var diff = vec3.Sub(self.origin);
        var t = max(diff.Dot(self.direction), 0);
        var scaled_dir = self.direction.Mul(t);
        return self.origin.Add(scaled_dir);
    };
}

function ColLine(start, finish) constructor {
    self.start = start;                     // Vec3
    self.finish = finish;                   // Vec3
    
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