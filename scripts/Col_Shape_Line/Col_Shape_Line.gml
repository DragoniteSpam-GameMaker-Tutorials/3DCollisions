function ColLine(start, finish) constructor {
    self.start = start;                     // Vec3
    self.finish = finish;                   // Vec3
    
    self.RecalculateProperties();
    
    static SetEnds = function(start, finish) {
        self.start = start;
        self.finish = finish;
        self.RecalculateProperties();
        return self;
    };
    
    static RecalculateProperties = function() {
        self.property_min = self.start.Min(self.finish);
        self.property_max = self.start.Max(self.finish);
        self.property_ray = new ColRay(self.start, self.finish.Sub(self.start));
        self.property_length = self.start.DistanceTo(self.finish);
        self.property_center = self.start.Add(self.finish).Div(2);
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckLine(self);
    };
    
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
    
    static CheckOBB = function(obb) {
        return obb.CheckLine(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckLine(self);
    };
    
    static CheckTriangle = function(triangle) {
        return triangle.CheckLine(self);
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckLine(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckLine(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        return false;
    };
    
    static CheckLine = function(line) {
        return false;
    };
    
    static DisplaceSphere = function(sphere) {
        return undefined;
    };
    
    static Length = function() {
        return self.property_length;
    };
    
    static NearestPoint = function(vec3) {
        var start = self.start;
        var finish = self.finish;
        var lvx = finish.x - start.x;
        var lvy = finish.y - start.y;
        var lvz = finish.z - start.z;
        var px = vec3.x - start.x;
        var py = vec3.y - start.y;
        var pz = vec3.z - start.z;
        var t = clamp(dot_product_3d(px, py, pz, lvx, lvy, lvz) / dot_product_3d(lvx, lvy, lvz, lvx, lvy, lvz), 0, 1);
        return new Vector3(
            start.x + lvx * t,
            start.y + lvy * t,
            start.z + lvz * t
        );
    };
    
    static NearestConnectionToRay = function(ray) {
        var line1 = self;
        var line2 = ray;
        
        var start = line1.start;
        var finish = line1.finish;
        var origin = line2.origin;
        var dir = line2.direction;
        
        var d1x = finish.x - start.x;
        var d1y = finish.y - start.y;
        var d1z = finish.z - start.z;
        var d2x = dir.x;
        var d2y = dir.y;
        var d2z = dir.z;
        var rx = start.x - origin.x;
        var ry = start.y - origin.y;
        var rz = start.z - origin.z;
        
        var f = dot_product_3d(d2x, d2y, d2z, rx, ry, rz);
        var c = dot_product_3d(d1x, d1y, d1z, rx, ry, rz);
        var b = dot_product_3d(d1x, d1y, d1z, d2y, d2z, d2z);
        var length_squared = dot_product_3d(d1x, d1y, d1z, d1x, d1y, d1z);
        
        // special case if the line segment is actually just
        // two of the same points
        if (length_squared == 0) {
            return new ColLine(start, line2.NearestPoint(start));
        }
        
        var f1 = 0;
        var f2 = 0;
        var denominator = length_squared - b * b;
        
        // if the two lines are parallel, there are infinitely many shortest
        // connecting lines, so you can just pick a random point on line1 to
        // work from - we'll pick the starting point
        if (denominator == 0) {
            f1 = 0;
        } else {
            f1 = clamp((b * f - c - 1) / denominator, 0, 1);
        }
        f2 = f1 * b + f;
        
        if (f2 < 0) {
            f2 = 0;
            f1 = clamp(-c / length_squared, 0, 1);
        }
        
        return new ColLine(
            new Vector3(
                start.x + d1x * f1,
                start.y + d1y * f1,
                start.z + d1z * f1
            ), new Vector3(
                origin.x + d2x * f2,
                origin.y + d2y * f2,
                origin.z + d2z * f2
            )
        );
    };
    
    static NearestConnectionToLine = function(line) {
        var nearest_connection_to_ray = self.NearestConnectionToRay(line.property_ray);
        
        var starting_point = line.NearestPoint(nearest_connection_to_ray.start);
        var ending_point = self.NearestPoint(nearest_connection_to_ray.finish);
        
        return new ColLine(starting_point, ending_point);
    };
    
    static GetMin = function() {
        return self.property_min;
    };
    
    static GetMax = function() {
        return self.property_max;
    };
}