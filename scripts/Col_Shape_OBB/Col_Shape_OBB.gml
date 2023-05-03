function ColOBB(position, size, orientation) constructor {
    self.position = position;               // Vec3
    self.size = size;                       // Vec3
    self.orientation = orientation;         // mat4
    
    static CheckObject = function(object) {
        return object.shape.CheckOBB(self);
    };
    
    static CheckPoint = function(point) {
        var dir = point.position.Sub(self.position);
        
        var size_array = self.size.AsLinearArray();
        var orientation_array = self.orientation.AsVectorArray();
        
        for (var i = 0; i < 3; i++) {
            var axis = orientation_array[i];
            
            var dist = dir.Dot(axis);
            
            if (abs(dist) > abs(size_array[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckSphere = function(sphere) {
        var nearest = self.NearestPoint(sphere.position);
        var dist = nearest.DistanceTo(sphere.position);
        return dist <= sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        var axes = [
            new Vector3(1, 0, 0),
            new Vector3(0, 1, 0),
            new Vector3(0, 0, 1),
            
            self.orientation.x,
            self.orientation.y,
            self.orientation.z,
        ];
        
        for (var i = 0; i < 3; i++) {
            for (var j = 3; j < 6; j++) {
                array_push(axes, axes[i].Cross(axes[j]));
            }
        }
        
        for (var i = 0; i < 15; i++) {
            if (!col_overlap_axis(self, aabb, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckOBB = function(obb) {
        var axes = [
            obb.orientation.x,
            obb.orientation.y,
            obb.orientation.z,
            
            self.orientation.x,
            self.orientation.y,
            self.orientation.z,
        ];
        
        for (var i = 0; i < 3; i++) {
            for (var j = 3; j < 6; j++) {
                array_push(axes, axes[i].Cross(axes[j]));
            }
        }
        
        for (var i = 0; i < 15; i++) {
            if (!col_overlap_axis(self, obb, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckPlane = function(plane) {
        var plen = self.size.x * abs(plane.normal.Dot(self.orientation.x)) +
            self.size.y * abs(plane.normal.Dot(self.orientation.y)) +
            self.size.z * abs(plane.normal.Dot(self.orientation.z));
        
        var dist = plane.normal.Dot(self.position) - plane.distance;
        
        return abs(dist) < plen;
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckOBB(self);
    };
    
    static CheckTriangle = function(triangle) {
        var edges = [
            triangle.b.Sub(triangle.a),
            triangle.c.Sub(triangle.b),
            triangle.a.Sub(triangle.c),
        ];
        
        var axes = [
            self.orientation.x,
            self.orientation.y,
            self.orientation.z,
            
            triangle.GetNormal(),
        ];
        
        for (var i = 0; i < 3; i++) {
            for (var j = 0; j < 3; j++) {
                array_push(axes, axes[i].Cross(edges[j]));
            }
        }
        
        for (var i = 0; i < 13; i++) {
            if (!col_overlap_axis(self, triangle, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckOBB(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckOBB(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var size_array = self.size.AsLinearArray();
        
        var dir = self.position.Sub(ray.origin);
        
        var direction_dots = [
            self.orientation.x.Dot(ray.direction),
            self.orientation.y.Dot(ray.direction),
            self.orientation.z.Dot(ray.direction),
        ];
        
        var position_dots = [
            self.orientation.x.Dot(dir),
            self.orientation.y.Dot(dir),
            self.orientation.z.Dot(dir),
        ];
        
        var t = array_create(6, 0);
        
        for (var i = 0; i < 3; i++) {
            if (direction_dots[i] == 0) {
                if ((-position_dots[i] - size_array[i]) > 0 || (-position_dots[i] + size_array[i]) < 0) {
                    return false;
                }
                direction_dots[i] = 0.0001;
            }
            
            t[i * 2 + 0] = (position_dots[i] + size_array[i]) / direction_dots[i];
            t[i * 2 + 1] = (position_dots[i] - size_array[i]) / direction_dots[i];
        }
        
        var tmin = max(
            min(t[0], t[1]),
            min(t[2], t[3]),
            min(t[4], t[5])
        );
        
        var tmax = min(
            max(t[0], t[1]),
            max(t[2], t[3]),
            max(t[4], t[5])
        );
        
        if (tmax < 0) return false;
        if (tmin > tmax) return false;
        
        if (hit_info) {
            var contact_distance = (tmin < 0) ? tmax : tmin;
            var contact_normal = new Vector3(0, 0, 0);
            
            var contact_point = ray.origin.Add(ray.direction.Mul(contact_distance));
            
            var possible_normals = [
                self.orientation.x,
                self.orientation.x.Mul(-1),
                self.orientation.y,
                self.orientation.y.Mul(-1),
                self.orientation.z,
                self.orientation.z.Mul(-1),
            ];
            
            for (var i = 0; i < 6; i++) {
                if (contact_distance == t[i]) contact_normal = possible_normals[i];
            }
            
            hit_info.Update(contact_distance, self, contact_point, contact_normal);
        }
        
        return true;
    };
    
    static CheckLine = function(line) {
        var dir = line.finish.Sub(line.start).Normalize();
        var ray = new ColRay(line.start, dir);
        var hit_info = new RaycastHitInformation();
        if (self.CheckRay(ray, hit_info)) {
            return (hit_info.distance <= line.Length());
        }
        return false;
    };
    
    static NearestPoint = function(vec3) {
        var result = self.position;
        var dir = vec3.Sub(self.position);
        
        var size_array = self.size.AsLinearArray();
        var orientation_array = self.orientation.AsVectorArray();
        
        for (var i = 0; i < 3; i++) {
            var axis = orientation_array[i];
            
            var dist = dir.Dot(axis);
            
            dist = clamp(dist, -size_array[i], size_array[i]);
            result = result.Add(axis.Mul(dist));
        }
        
        return result;
    };
    
    static GetInterval = function(axis) {
        var vertices = self.GetVertices();
        
        var imin = axis.Dot(vertices[0]);
        var imax = imin;
        
        for (var i = 1; i < 8; i++) {
            var dot = axis.Dot(vertices[i]);
            imin = min(imin, dot);
            imax = max(imax, dot);
        }
        
        return new ColInterval(imin, imax);
    };
    
    static GetVertices = function() {
        return [
            self.position.Add(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
        ];
    };
    
    static GetEdges = function() {
        var vertices = self.GetVertices();
        
        return [
            new ColLine(vertices[1], vertices[6]),
            new ColLine(vertices[6], vertices[4]),
            new ColLine(vertices[4], vertices[7]),
            new ColLine(vertices[7], vertices[1]),
            new ColLine(vertices[0], vertices[3]),
            new ColLine(vertices[3], vertices[5]),
            new ColLine(vertices[5], vertices[1]),
            new ColLine(vertices[1], vertices[0]),
            new ColLine(vertices[7], vertices[2]),
            new ColLine(vertices[1], vertices[0]),
            new ColLine(vertices[6], vertices[3]),
            new ColLine(vertices[4], vertices[5]),
        ];
    };
    
    static GetMin = function() {
        var vertices = self.GetVertices();
        
        var point_min = new Vector3(infinity, infinity, infinity);
        for (var i = 0; i < array_length(vertices); i++) {
            point_min.x = min(point_min.x, vertices[i].x);
            point_min.y = min(point_min.y, vertices[i].y);
            point_min.z = min(point_min.z, vertices[i].z);
        }
        
        return point_min;
    };
    
    static GetMax = function() {
        var vertices = self.GetVertices();
        
        var point_max = new Vector3(-infinity, -infinity, -infinity);
        for (var i = 0; i < array_length(vertices); i++) {
            point_max.x = max(point_max.x, vertices[i].x);
            point_max.y = max(point_max.y, vertices[i].y);
            point_max.z = max(point_max.z, vertices[i].z);
        }
        
        return point_max;
    };
}