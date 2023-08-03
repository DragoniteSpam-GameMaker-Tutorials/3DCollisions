function ColOBB(position, size, orientation) constructor {
    self.position = position;               // Vec3
    self.size = size;                       // Vec3
    self.orientation = orientation;         // mat3
    
    self.RecalculateProperties();
    
    static SetPosition = function(position) {
        self.position = position;
        self.RecalculateProperties();
    };
    
    static SetSize = function(size) {
        self.size = size;
        self.RecalculateProperties();
    };
    
    static SetOrientation = function(orientation) {
        self.orientation = orientation;
        self.RecalculateProperties();
    };
    
    static RecalculateProperties = function() {
        self.vertices = [
            self.position.Add(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
        ];
        
        self.edges = [
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
        
        self.point_min = new Vector3(infinity, infinity, infinity);
        for (var i = 0; i < array_length(self.vertices); i++) {
            self.point_min.x = min(self.point_min.x, self.vertices[i].x);
            self.point_min.y = min(self.point_min.y, self.vertices[i].y);
            self.point_min.z = min(self.point_min.z, self.vertices[i].z);
        }
        
        self.point_max = new Vector3(infinity, infinity, infinity);
        for (var i = 0; i < array_length(self.vertices); i++) {
            self.point_max.x = min(self.point_max.x, self.vertices[i].x);
            self.point_max.y = min(self.point_max.y, self.vertices[i].y);
            self.point_max.z = min(self.point_max.z, self.vertices[i].z);
        }
        
        self.imaginary_radius = self.size.Magnitude();
    };
    
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
        //var distance = self.position.DistanceTo(sphere.position);
        var distance = point_distance_3d(self.position.x, self.position.y, self.position.z, sphere.position.x, sphere.position.y, sphere.position.z);
        
        if (distance > self.imaginary_radius + sphere.radius) return false;
        
        var nearest = self.NearestPoint(sphere.position);
        //var dist = nearest.DistanceTo(sphere.position);
        var dist = point_distance_3d(nearest.x, nearest.y, nearest.z, sphere.position.x, sphere.position.y, sphere.position.z);
        return dist < sphere.radius;
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
        var my_radius = self.size.Magnitude();
        var other_radius = obb.size.Magnitude();
        
        var distance = self.position.DistanceTo(obb.position);
        if (distance > my_radius + other_radius) return false;
        
        
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
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        if (self.position.DistanceTo(sphere.position) == 0) return undefined;
        
        var nearest = self.NearestPoint(sphere.position);
        
        if (nearest.DistanceTo(sphere.position) == 0) {
            return undefined;
            /*
            var dir_to_center = sphere.position.Sub(self.position).Normalize();
            var new_point = dir_to_center.Mul(self.half_extents.Magnitude());
            
            nearest = self.NearestPoint(new_point);
            var dir = nearest.Sub(sphere.position).Normalize();
            */
        } else {
            var dir = sphere.position.Sub(nearest).Normalize();
        }
        
        return nearest.Add(dir.Mul(sphere.radius));
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
        
        var xx = axis.x;
        var yy = axis.y;
        var zz = axis.z;
        
        var imin = infinity;
        var imax = -infinity;
        
        for (var i = 0; i < 8; i++) {
            var vertex = vertices[i];
            var dot = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            imin = min(imin, dot);
            imax = max(imax, dot);
        }
        
        return new ColInterval(imin, imax);
    };
    
    static GetVertices = function() {
        return self.vertices;
    };
    
    static GetEdges = function() {
        return self.edges;
    };
    
    static GetMin = function() {
        return self.point_min;
    };
    
    static GetMax = function() {
        return self.point_max;
    };
}