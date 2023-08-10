function ColCapsule(start, finish, radius) constructor {
    self.line = new ColLine(start, finish);
    self.radius = radius;
    
    self.RecalculateProperties();
    
    static SetEnds = function(start, finish) {
        self.line.SetEnds(start, finish);
        self.RecalculateProperties();
        return self;
    };
    
    static SetRadius = function(radius) {
        self.radius = radius;
        self.RecalculateProperties();
        return self;
    };
    
    static RecalculateProperties = function() {
        self.property_center = self.line.property_center;
        self.property_radius = self.line.property_length / 2 + self.radius;
        self.property_min = self.line.property_min.Sub(self.radius);
        self.property_max = self.line.property_min.Add(self.radius);
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckCapsule(self);
    };
    
    static CheckPoint = function(point) {
        var nearest = self.line.NearestPoint(point.position);
        var dist = nearest.DistanceTo(point.position);
        
        return dist < self.radius;
    };
    
    static CheckSphere = function(sphere) {
        var nearest = self.line.NearestPoint(sphere.position);
        var dist = nearest.DistanceTo(sphere.position);
        
        return dist < (self.radius + sphere.radius);
    };
    
    static CheckAABB = function(aabb) {
        static test_sphere = new ColSphere(new Vector3(0, 0, 0), 0);
        test_sphere.position = self.line.start;
        test_sphere.radius = self.radius;
        if (test_sphere.CheckAABB(aabb)) return true;
        
        test_sphere.position = self.line.finish;
        if (test_sphere.CheckAABB(aabb)) return true;
        
        var edges = aabb.property_edges;
        
        var i = 0;
        repeat (12) {
            var nearest_line_to_edge = edges[i++].NearestConnectionToLine(self.line);
            var nearest_start = nearest_line_to_edge.start;
            var nearest_self = self.line.NearestPoint(nearest_start);
            
            var start_distance = point_distance_3d(nearest_self.x, nearest_self.y, nearest_self.z, nearest_start.x, nearest_start.y, nearest_start.z);
            if (start_distance == 0) {
                test_sphere.position = nearest_line_to_edge.start;
                if (test_sphere.CheckAABB(aabb)) return true;
            } else {
                test_sphere.position = nearest_line_to_edge.finish;
                if (test_sphere.CheckAABB(aabb)) return true;
            }
        }
        
        return false;
    };
    
    static CheckPlane = function(plane) {
        var nearest_start = plane.NearestPoint(self.line.start);
        if (self.line.start.DistanceTo(nearest_start) < self.radius) return true;
        
        var nearest_finish = plane.NearestPoint(self.line.finish);
        if (self.line.finish.DistanceTo(nearest_finish) < self.radius) return true;
        
        return self.line.CheckPlane(plane);
    };
    
    static CheckOBB = function(obb) {
        static test_sphere = new ColSphere(new Vector3(0, 0, 0), 0);
        test_sphere.position = self.line.start;
        test_sphere.radius = self.radius;
        if (obb.CheckSphere(test_sphere)) return true;
        
        test_sphere.position = self.line.finish;
        if (obb.CheckSphere(test_sphere)) return true;
        
        var edges = obb.property_edges;
        
        var i = 0;
        repeat (12) {
            var nearest_line_to_edge = edges[i++].NearestConnectionToLine(self.line);
            var nearest_start = nearest_line_to_edge.start;
            var nearest_self = self.line.NearestPoint(nearest_start);
            
            var start_distance = point_distance_3d(nearest_self.x, nearest_self.y, nearest_self.z, nearest_start.x, nearest_start.y, nearest_start.z);
            if (start_distance == 0) {
                test_sphere.position = nearest_line_to_edge.start;
                if (obb.CheckSphere(test_sphere)) return true;
            } else {
                test_sphere.position = nearest_line_to_edge.finish;
                if (obb.CheckSphere(test_sphere)) return true;
            }
        }
        
        return false;
    };
    
    static CheckCapsule = function(capsule) {
        var connecting_line = self.line.NearestConnectionToLine(capsule.line);
        return connecting_line.property_length < (self.radius + capsule.radius);
    };
    
    static CheckTriangle = function(triangle) {
        var nearest_point_start = triangle.NearestPoint(self.line.start);
        var capsule_line_nearest_point_start = self.line.NearestPoint(nearest_point_start);
        if (capsule_line_nearest_point_start.DistanceTo(nearest_point_start) < self.radius) return true;
        
        var nearest_point_finish = triangle.NearestPoint(self.line.finish);
        var capsule_line_nearest_point_finish = self.line.NearestPoint(nearest_point_finish);
        if (capsule_line_nearest_point_finish.DistanceTo(nearest_point_finish) < self.radius) return true;
        
        return false;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckCapsule(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckCapsule(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var capsule_dir = self.line.finish.Sub(self.line.start);
        var relative_ray_origin = ray.origin.Sub(self.line.start);
        
        var baba = capsule_dir.Dot(capsule_dir);
        var bard = capsule_dir.Dot(ray.direction);
        var baoa = capsule_dir.Dot(relative_ray_origin);
        var rdoa = ray.direction.Dot(relative_ray_origin);
        var oaoa = relative_ray_origin.Dot(relative_ray_origin);
        
        var a = baba - sqr(bard);
        var b = baba * rdoa - baoa * bard;
        var c = baba * oaoa - sqr(baoa) - sqr(self.radius) * baba;
        var h = sqr(b) - a * c;
        
        if (h > 0) {
            var t = (-b - sqrt(h)) / a;
            var why = baoa + t * bard;
            
            if (why > 0 && why < baba) {
                var contact_point = ray.origin.Add(ray.direction.Mul(t));
                var nearest_inner_point = self.line.NearestPoint(contact_point);
                var contact_normal = contact_point.Sub(nearest_inner_point).Normalize();
                hit_info.Update(t, self, contact_point, contact_normal);
                return true;
            }
            
            var oc = (why <= 0) ? relative_ray_origin : ray.origin.Sub(self.line.finish);
            b = ray.direction.Dot(oc);
            c = oc.Dot(oc) - sqr(self.radius);
            h = sqr(b) - c;
            
            if (h > 0) {
                t = -b - sqrt(h);
                var contact_point = ray.origin.Add(ray.direction.Mul(t));
                var nearest_inner_point = self.line.NearestPoint(contact_point);
                var contact_normal = contact_point.Sub(nearest_inner_point).Normalize();
                hit_info.Update(t, self, contact_point, contact_normal);
                return true;
            }
        }
        
        return false;
    };
    
    static CheckLine = function(line) {
        var closest_line = self.line.NearestConnectionToLine(line);
        return closest_line.property_length < self.radius;
    };
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        var nearest = self.line.NearestPoint(sphere.position);
        
        if (nearest.DistanceTo(sphere.position) == 0) return undefined;
        
        var dir = sphere.position.Sub(nearest).Normalize();
        var offset = dir.Mul(sphere.radius + self.radius);
        
        return nearest.Add(offset);
    };
    
    static GetMin = function() {
        return self.property_min;
    };
    
    static GetMax = function() {
        return self.property_max;
    };
}