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
        var start = self.line.start;
        var nearest = plane.NearestPoint(start);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, start.x, start.y, start.z) < self.radius) return true;
        
        var finish = self.line.finish;
        var nearest = plane.NearestPoint(finish);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, finish.x, finish.y, finish.z) < self.radius) return true;
        
        return self.line.CheckPlane(plane);
    };
    
    static CheckOBB = function(obb) {
        var obb_position = obb.position;
        var obb_size_array = [obb.size.x, obb.size.y, obb.size.z];
        var obb_orientation_array = [obb.orientation.x, obb.orientation.y, obb.orientation.z];
        
        var r = self.radius;
        var line = self.line;
        var p = line.start;
        
        var nx = obb_position.x, ny = obb_position.y, nz = obb_position.z;
        var dx = p.x - nx, dy = p.y - ny, dz = p.z - nz;
        
        for (var i = 0; i < 3; i++) {
            var axis = obb_orientation_array[i];
            var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
            dist = clamp(dist, -obb_size_array[i], obb_size_array[i]);
            nx += axis.x * dist;
            ny += axis.y * dist;
            nz += axis.z * dist;
        }
        
        if (point_distance_3d(nx, ny, nz, p.x, p.y, p.z) < r) return true;
        p = line.finish;
        
        var nx = obb_position.x, ny = obb_position.y, nz = obb_position.z;
        var dx = p.x - nx, dy = p.y - ny, dz = p.z - nz;
        
        for (var i = 0; i < 3; i++) {
            var axis = obb_orientation_array[i];
            var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
            dist = clamp(dist, -obb_size_array[i], obb_size_array[i]);
            nx += axis.x * dist;
            ny += axis.y * dist;
            nz += axis.z * dist;
        }
        
        if (point_distance_3d(nx, ny, nz, p.x, p.y, p.z) < r) return true;
        
        var edges = obb.property_edges;
        
        var i = 0;
        repeat (12) {
            var nearest_line_to_edge = edges[i++].NearestConnectionToLine(line);
            var nearest_start = nearest_line_to_edge.start;
            var nearest_self = line.NearestPoint(nearest_start);
            
            p = (nearest_self.x == nearest_start.x && nearest_self.y == nearest_start.y && nearest_self.z == nearest_start.z) ? nearest_line_to_edge.start : nearest_line_to_edge.finish;
            
            var nx = obb_position.x, ny = obb_position.y, nz = obb_position.z;
            var dx = p.x - nx, dy = p.y - ny, dz = p.z - nz;
            
            for (var i = 0; i < 3; i++) {
                var axis = obb_orientation_array[i];
                var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
                dist = clamp(dist, -obb_size_array[i], obb_size_array[i]);
                nx += axis.x * dist;
                ny += axis.y * dist;
                nz += axis.z * dist;
            }
            
            if (point_distance_3d(nx, ny, nz, p.x, p.y, p.z) < r) return true;
        }
        
        return false;
    };
    
    static CheckCapsule = function(capsule) {
        var connecting_line = self.line.NearestConnectionToLine(capsule.line);
        return connecting_line.property_length < (self.radius + capsule.radius);
    };
    
    static CheckTriangle = function(triangle) {
        var line = self.line;
        var target = triangle.NearestPoint(line.start);
        var nearest = line.NearestPoint(target);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, target.x, target.y, target.z) < self.radius) return true;
        
        var target = triangle.NearestPoint(line.finish);
        var nearest = line.NearestPoint(target);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, target.x, target.y, target.z) < self.radius) return true;
        
        return false;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckCapsule(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckCapsule(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var c = self.property_center;
        var nearest = ray.NearestPoint(c);
        if (point_distance_3d(nearest.x, nearest.y, nearest.z, c.x, c.y, c.z) >= self.property_radius) return false;
        
        var line = self.line;
        var cd = line.property_ray.direction;
        var rd = ray.direction;
        var ro = ray.origin;
        var relative_ray_origin = ro.Sub(line.start);
        
        var baba = dot_product_3d(cd.x, cd.x, cd.y, cd.y, cd.z, cd.z);
        var bard = dot_product_3d(cd.x, cd.x, cd.y, rd.y, rd.z, rd.z);
        var baoa = dot_product_3d(cd.x, cd.x, cd.y, relative_ray_origin.y, relative_ray_origin.z, relative_ray_origin.z);
        var rdoa = dot_product_3d(rd.x, rd.x, rd.y, relative_ray_origin.y, relative_ray_origin.z, relative_ray_origin.z);
        var oaoa = dot_product_3d(relative_ray_origin.x, relative_ray_origin.x, relative_ray_origin.y, relative_ray_origin.y, relative_ray_origin.z, relative_ray_origin.z);
        
        var a = baba - sqr(bard);
        var b = baba * rdoa - baoa * bard;
        var c = baba * oaoa - sqr(baoa) - sqr(self.radius) * baba;
        var h = sqr(b) - a * c;
        
        if (h > 0) {
            var t = (-b - sqrt(h)) / a;
            var why = baoa + t * bard;
            
            if (why > 0 && why < baba) {
                if (hit_info) {
                    var contact_point = ro.Add(rd.Mul(t));
                    var nearest_inner_point = line.NearestPoint(contact_point);
                    var contact_normal = contact_point.Sub(nearest_inner_point).Normalize();
                    hit_info.Update(t, self, contact_point, contact_normal);
                }
                return true;
            }
            
            var oc = (why <= 0) ? relative_ray_origin : ro.Sub(line.finish);
            b = dot_product_3d(rd.x, rd.y, rd.z, oc.x, oc.y, oc.z);
            c = dot_product_3d(oc.x, oc.y, oc.z, oc.x, oc.y, oc.z) - sqr(self.radius);
            h = sqr(b) - c;
            
            if (h > 0) {
                if (hit_info) {
                    t = -b - sqrt(h);
                    var contact_point = ro.Add(rd.Mul(t));
                    var nearest_inner_point = line.NearestPoint(contact_point);
                    var contact_normal = contact_point.Sub(nearest_inner_point).Normalize();
                    hit_info.Update(t, self, contact_point, contact_normal);
                }
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
        
        var ps = sphere.position;
        var nearest = self.line.NearestPoint(ps);
        
        if (ps.x == nearest.x && ps.y == nearest.y && ps.z == nearest.z) return undefined;
        
        var dir = ps.Sub(nearest).Normalize();
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