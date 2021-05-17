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
    
    static CheckRay = function(ray) {
        
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
        
    };
    
    static CheckAABB = function(aabb) {
        
    };
    
    static CheckPlane = function(plane) {
        
    };
    
    static CheckRay = function(ray) {
        
    };
    
    static CheckLine = function(line) {
        
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
        
    };
    
    static CheckPlane = function(plane) {
        
    };
    
    static CheckRay = function(ray) {
        
    };
    
    static CheckLine = function(line) {
        
    };
    
    static GetMin = function() {
        return self.position.Sub(self.half_extents);
    };
    
    static GetMax = function() {
        return self.position.Add(self.half_extents);
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
        
    };
    
    static CheckRay = function(ray) {
        
    };
    
    static CheckLine = function(line) {
        
    };
}

// Line "shapes"
function ColRay(origin, direction) constructor {
    self.origin = origin;                   // Vec3
    self.direction = direction;             // Vec3
}

function ColLine(start, finish) constructor {
    self.start = start;                     // Vec3
    self.finish = finish;                   // Vec3
    
    static Length = function() {
        return self.start.DistanceTo(self.finish);
    };
}