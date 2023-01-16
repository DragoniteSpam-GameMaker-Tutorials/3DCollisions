function ColCapsule(start, finish, radius) constructor {
    self.line = new ColLine(start, finish);
    self.radius = radius;
    
    static CheckObject = function(object) {
        return object.shape.CheckCapsule(self);
    };
    
    static CheckPoint = function(point) {
        var nearest = self.line.NearestPoint(point.position);
        var dist = nearest.DistanceTo(point.position);
        
        return dist <= self.radius;
    };
    
    static CheckSphere = function(sphere) {
        var nearest = self.line.NearestPoint(sphere.position);
        var dist = nearest.DistanceTo(sphere.position);
        
        return dist <= (self.radius + sphere.radius);
    };
    
    static CheckAABB = function(aabb) {
        
    };
    
    static CheckPlane = function(plane) {
        var nearest_start = plane.NearestPoint(self.line.start);
        if (self.line.start.DistanceTo(nearest_start) <= self.radius) return true;
        
        var nearest_finish = plane.NearestPoint(self.line.finish);
        if (self.line.finish.DistanceTo(nearest_finish) <= self.radius) return true;
        
        return self.line.CheckPlane(plane);
    };
    
    static CheckOBB = function(obb) {
        
    };
    
    static CheckCapsule = function(capsule) {
        var connecting_line = self.line.NearestConnectionToLine(capsule.line);
        var dist = connecting_line.Length();
        
        return dist <= (self.radius + capsule.radius);
    };
    
    static CheckTriangle = function(triangle) {
        
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckCapsule(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        
    };
    
    static CheckLine = function(line) {
        
    };
}