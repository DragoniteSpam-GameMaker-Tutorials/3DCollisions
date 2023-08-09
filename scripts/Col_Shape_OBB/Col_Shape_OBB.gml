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
        self.property_vertices = [
            self.position.Add(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
        ];
        
        var vertices = self.property_vertices;
        
        self.property_edges = [
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
        
        self.property_min = new Vector3(infinity, infinity, infinity);
        for (var i = 0; i < array_length(vertices); i++) {
            self.property_min.x = min(self.property_min.x, vertices[i].x);
            self.property_min.y = min(self.property_min.y, vertices[i].y);
            self.property_min.z = min(self.property_min.z, vertices[i].z);
        }
        
        self.property_max = new Vector3(infinity, infinity, infinity);
        for (var i = 0; i < array_length(vertices); i++) {
            self.property_max.x = min(self.property_max.x, vertices[i].x);
            self.property_max.y = min(self.property_max.y, vertices[i].y);
            self.property_max.z = min(self.property_max.z, vertices[i].z);
        }
        
        self.imaginary_radius = self.size.Magnitude();
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckOBB(self);
    };
    
    static CheckPoint = function(point) {
        var dir = point.position.Sub(self.position);
        
        var size_array = self.size.linear_array;
        var orientation_array = self.orientation.vector_array;
        
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
        var ps = sphere.position;
        var po = self.position;
        var distance = point_distance_3d(po.x, po.y, po.z, ps.x, ps.y, ps.z);
        
        if (distance > self.imaginary_radius + sphere.radius) return false;
        
        var nearest = self.NearestPoint(ps);
        return point_distance_3d(nearest.x, nearest.y, nearest.z, ps.x, ps.y, ps.z) < sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        static vec_x = new Vector3(1, 0, 0);
        static vec_y = new Vector3(0, 1, 0);
        static vec_z = new Vector3(0, 0, 1);
        
        static axes = [
            vec_x, vec_y, vec_z,
            undefined, undefined, undefined,
            undefined, undefined, undefined,
            undefined, undefined, undefined,
            undefined, undefined, undefined
        ];
        
        var ox = self.orientation.x;
        var oy = self.orientation.y;
        var oz = self.orientation.z;
        
        axes[3] = ox;
        axes[4] = oy;
        axes[5] = oz;
        
        axes[6] = vec_x.Cross(ox);
        axes[7] = vec_y.Cross(ox);
        axes[8] = vec_z.Cross(ox);
        axes[9] = vec_x.Cross(oy);
        axes[10] = vec_y.Cross(oy);
        axes[11] = vec_z.Cross(oy);
        axes[12] = vec_x.Cross(oz);
        axes[13] = vec_y.Cross(oz);
        axes[14] = vec_z.Cross(oz);
        
        var i = 0;
        repeat (15) {
            if (!col_overlap_axis(self, aabb, axes[i++])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckOBB = function(obb) {
        var p1 = self.position;
        var p2 = obb.position;
        
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) > self.imaginary_radius + obb.imaginary_radius) return false;
        
        static axes = array_create(15);
        
        var ix = obb.orientation.x;
        var iy = obb.orientation.y;
        var iz = obb.orientation.z;
        var ox = self.orientation.x;
        var oy = self.orientation.y;
        var oz = self.orientation.z;
        
        axes[0] = ix;
        axes[1] = iy;
        axes[2] = iz;
        
        axes[3] = ox;
        axes[4] = oy;
        axes[5] = oz;
        
        axes[6] = ix.Cross(ox);
        axes[7] = iy.Cross(ox);
        axes[8] = iz.Cross(ox);
        axes[9] = ix.Cross(oy);
        axes[10] = iy.Cross(oy);
        axes[11] = iz.Cross(oy);
        axes[12] = ix.Cross(oz);
        axes[13] = iy.Cross(oz);
        axes[14] = iz.Cross(oz);
        
        var i = 0;
        repeat (15) {
            if (!col_overlap_axis(self, obb, axes[i++])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckPlane = function(plane) {
        var normal = plane.normal;
        var nx = normal.x;
        var ny = normal.y;
        var nz = normal.z;
        var ox = self.orientation.x;
        var oy = self.orientation.y;
        var oz = self.orientation.z;
        var p = self.position;
        var plen =
            self.size.x * abs(dot_product_3d(nx, ny, nz, ox, oy, oz)) +
            self.size.y * abs(dot_product_3d(nx, ny, nz, ox, oy, oz)) +
            self.size.z * abs(dot_product_3d(nx, ny, nz, ox, oy, oz));
        
        var dist = dot_product_3d(nx, ny, nz, p.x, p.y, p.z) - plane.distance;
        
        return abs(dist) < plen;
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckOBB(self);
    };
    
    static CheckTriangle = function(triangle) {
        static axes = array_create(13);
        
        var ab = triangle.property_edge_ab;
        var bc = triangle.property_edge_bc;
        var ca = triangle.property_edge_ca;
        
        var ox = self.orientation.x;
        var oy = self.orientation.y;
        var oz = self.orientation.z;
        var tn = triangle.property_normal;
        
        axes[0] = ox;
        axes[1] = oy;
        axes[2] = oz;
        axes[3] = tn;
        
        axes[4] = ox.Cross(ab);
        axes[5] = ox.Cross(bc);
        axes[6] = ox.Cross(ca);
        axes[7] = oy.Cross(ab);
        axes[8] = oy.Cross(bc);
        axes[9] = oy.Cross(ca);
        axes[10] = oz.Cross(ab);
        axes[11] = oz.Cross(bc);
        axes[12] = oz.Cross(ca);
        
        var i = 0;
        repeat (13) {
            if (!col_overlap_axis(self, triangle, axes[i++])) {
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
        var size_array = self.size.linear_array;
        
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
        static hit_info = new RaycastHitInformation();
        hit_info.Clear();
        
        if (self.CheckRay(line.property_ray, hit_info)) {
            return (hit_info.distance <= line.property_length);
        }
        return false;
    };
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        if (self.position.DistanceTo(sphere.position) == 0) return undefined;
        
        var nearest = self.NearestPoint(sphere.position);
        
        if (nearest.DistanceTo(sphere.position) == 0) {
            return undefined;
        } else {
            var dir = sphere.position.Sub(nearest).Normalize();
        }
        
        return nearest.Add(dir.Mul(sphere.radius));
    };
    
    static NearestPoint = function(vec3) {
        var result = self.position;
        var dir = vec3.Sub(self.position);
        
        var size_array = self.size.linear_array;
        var orientation_array = self.orientation.vector_array;
        
        for (var i = 0; i < 3; i++) {
            var axis = orientation_array[i];
            
            var dist = dir.Dot(axis);
            
            dist = clamp(dist, -size_array[i], size_array[i]);
            result = result.Add(axis.Mul(dist));
        }
        
        return result;
    };
    
    static GetInterval = function(axis) {
        var vertices = self.property_vertices;
        
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
        return self.property_vertices;
    };
    
    static GetEdges = function() {
        return self.property_edges;
    };
    
    static GetMin = function() {
        return self.property_min;
    };
    
    static GetMax = function() {
        return self.property_max;
    };
}