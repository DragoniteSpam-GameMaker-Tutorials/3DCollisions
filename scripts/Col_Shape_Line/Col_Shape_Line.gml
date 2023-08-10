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
        var line_vec = self.finish.Sub(self.start);
        var point_vec = vec3.Sub(self.start);
        var t = clamp(point_vec.Dot(line_vec) / line_vec.Dot(line_vec), 0, 1);
        var scaled_vec = line_vec.Mul(t);
        return self.start.Add(scaled_vec);
    };
    
    static NearestConnectionToRay = function(ray) {
        var line1 = self;
        var line2 = ray;
        
        var d1 = line1.finish.Sub(line1.start);
        var d2 = line2.direction;
        var r = line1.start.Sub(line2.origin);
        var f = d2.Dot(r);
        var c = d1.Dot(r);
        var b = d1.Dot(d2);
        var length_squared = d1.Dot(d1);
        
        // special case if the line segment is actually just
        // two of the same points
        if (length_squared == 0) {
            return new ColLine(line1.start, line2.NearestPoint(line1.start));
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
        
        return new ColLine(line1.start.Add(d1.Mul(f1)), line2.origin.Add(d2.Mul(f2)));
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