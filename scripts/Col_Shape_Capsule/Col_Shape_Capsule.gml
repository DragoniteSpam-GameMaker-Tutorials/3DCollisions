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
        var endcap_start = new ColSphere(self.line.start, self.radius);
        if (endcap_start.CheckAABB(aabb)) return true;
        
        var endcap_finish = new ColSphere(self.line.finish, self.radius);
        if (endcap_finish.CheckAABB(aabb)) return true;
        
        var edges = aabb.GetEdges();
        
        for (var i = 0, n = array_length(edges); i < n; i++) {
            var nearest_line_to_edge = edges[i].NearestConnectionToLine(self.line);
            var start_distance = self.line.NearestPoint(nearest_line_to_edge.start).DistanceTo(nearest_line_to_edge.start);
            if (start_distance == 0) {
                var test_sphere = new ColSphere(nearest_line_to_edge.start, self.radius);
                if (test_sphere.CheckAABB(aabb)) return true;
            } else {
                var test_sphere = new ColSphere(nearest_line_to_edge.finish, self.radius);
                if (test_sphere.CheckAABB(aabb)) return true;
            }
        }
        
        return false;
    };
    
    static CheckPlane = function(plane) {
        var nearest_start = plane.NearestPoint(self.line.start);
        if (self.line.start.DistanceTo(nearest_start) <= self.radius) return true;
        
        var nearest_finish = plane.NearestPoint(self.line.finish);
        if (self.line.finish.DistanceTo(nearest_finish) <= self.radius) return true;
        
        return self.line.CheckPlane(plane);
    };
    
    static CheckOBB = function(obb) {
        var endcap_start = new ColSphere(self.line.start, self.radius);
        if (endcap_start.CheckOBB(obb)) return true;
        
        var endcap_finish = new ColSphere(self.line.finish, self.radius);
        if (endcap_finish.CheckOBB(obb)) return true;
        
        var edges = obb.GetEdges();
        
        for (var i = 0, n = array_length(edges); i < n; i++) {
            var nearest_line_to_edge = edges[i].NearestConnectionToLine(self.line);
            var start_distance = self.line.NearestPoint(nearest_line_to_edge.start).DistanceTo(nearest_line_to_edge.start);
            if (start_distance == 0) {
                var test_sphere = new ColSphere(nearest_line_to_edge.start, self.radius);
                if (test_sphere.CheckOBB(obb)) return true;
            } else {
                var test_sphere = new ColSphere(nearest_line_to_edge.finish, self.radius);
                if (test_sphere.CheckOBB(obb)) return true;
            }
        }
        
        return false;
    };
    
    static CheckCapsule = function(capsule) {
        var connecting_line = self.line.NearestConnectionToLine(capsule.line);
        var dist = connecting_line.Length();
        
        return dist <= (self.radius + capsule.radius);
    };
    
    static CheckTriangle = function(triangle) {
        var nearest_point_start = triangle.NearestPoint(self.line.start);
        var capsule_line_nearest_point_start = self.line.NearestPoint(nearest_point_start);
        if (capsule_line_nearest_point_start.DistanceTo(nearest_point_start) <= self.radius) return true;
        
        var nearest_point_finish = triangle.NearestPoint(self.line.finish);
        var capsule_line_nearest_point_finish = self.line.NearestPoint(nearest_point_finish);
        if (capsule_line_nearest_point_finish.DistanceTo(nearest_point_finish) <= self.radius) return true;
        
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
        return closest_line.Length() <= self.radius;
    };
    
    static GetMin = function() {
        return self.line.GetMin().Sub(self.radius);
    };
    
    static GetMax = function() {
        return self.line.GetMin().Add(self.radius);
    };
}