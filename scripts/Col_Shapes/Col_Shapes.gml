// Some basic shapes
function ColPoint(position) constructor {
    self.position = position;               // Vec3
    
    static CheckPoint = function(point) {
        
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
    self.normal = normal;                   // Vec3
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