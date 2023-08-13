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
        var p = self.position;
        var s = self.size;
        var xs = self.orientation.x.Mul(s.x);
        var ys = self.orientation.y.Mul(s.y);
        var zs = self.orientation.z.Mul(s.z);
        
        self.property_vertices = [
            p.Add(xs).Add(ys).Add(zs),
            p.Sub(xs).Add(ys).Add(zs),
            p.Add(xs).Sub(ys).Add(zs),
            p.Add(xs).Add(ys).Sub(zs),
            p.Sub(xs).Sub(ys).Sub(zs),
            p.Add(xs).Sub(ys).Sub(zs),
            p.Sub(xs).Add(ys).Sub(zs),
            p.Sub(xs).Sub(ys).Add(zs),
        ];
        
        var vertices = self.property_vertices;
        
        self.property_edges = [
            new ColLine(vertices[1], vertices[6]),
            new ColLine(vertices[6], vertices[4]),
            new ColLine(vertices[4], vertices[7]),
            new ColLine(vertices[7], vertices[1]),
            new ColLine(vertices[0], vertices[3]),
            new ColLine(vertices[3], vertices[5]),
            new ColLine(vertices[5], vertices[2]),
            new ColLine(vertices[1], vertices[0]),
            new ColLine(vertices[7], vertices[2]),
            new ColLine(vertices[2], vertices[0]),
            new ColLine(vertices[6], vertices[3]),
            new ColLine(vertices[4], vertices[5]),
        ];
        
        self.property_min = new Vector3(infinity, infinity, infinity);
        for (var i = 0; i < array_length(vertices); i++) {
            self.property_min.x = min(self.property_min.x, vertices[i].x);
            self.property_min.y = min(self.property_min.y, vertices[i].y);
            self.property_min.z = min(self.property_min.z, vertices[i].z);
        }
        
        self.property_max = new Vector3(-infinity, -infinity, -infinity);
        for (var i = 0; i < array_length(vertices); i++) {
            self.property_max.x = max(self.property_max.x, vertices[i].x);
            self.property_max.y = max(self.property_max.y, vertices[i].y);
            self.property_max.z = max(self.property_max.z, vertices[i].z);
        }
        
        self.imaginary_radius = point_distance_3d(s.x, s.y, s.z, 0, 0, 0);
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckOBB(self);
    };
    
    static CheckPoint = function(point) {
        var pp = point.position;
        var po = self.position;
        if (point_distance_3d(po.x, po.y, po.z, pp.x, pp.y, pp.z) > self.imaginary_radius) return false;
        
        var dir = pp.Sub(po);
        var dx = dir.x, dy = dir.y, dz = dir.z;
        
        var size_array = [self.size.x, self.size.y, self.size.z];
        var orientation_array = [self.orientation.x, self.orientation.y, self.orientation.z];
        
        for (var i = 0; i < 3; i++) {
            var axis = orientation_array[i];
            var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
            
            if (abs(dist) > abs(size_array[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckSphere = function(sphere) {
        var ps = sphere.position;
        var po = self.position;
        if (point_distance_3d(po.x, po.y, po.z, ps.x, ps.y, ps.z) > self.imaginary_radius + sphere.radius) return false;
        
        var nearest = self.NearestPoint(ps);
        return point_distance_3d(nearest.x, nearest.y, nearest.z, ps.x, ps.y, ps.z) < sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        var p1 = self.position;
        var p2 = aabb.position;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) > aabb.property_radius + self.imaginary_radius) return false;
        
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
            var axis = axes[i++];
            var a = self.GetInterval(axis);
            var b = aabb.GetInterval(axis);
            if ((b.val_min > a.val_max) || (a.val_min > b.val_max)) {
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
            var axis = axes[i++];
            var a = self.GetInterval(axis);
            var b = obb.GetInterval(axis);
            if ((b.val_min > a.val_max) || (a.val_min > b.val_max)) {
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
        var p1 = self.position;
        var p2 = triangle.property_center;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) > triangle.property_radius + self.imaginary_radius) return false;
        
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
            var axis = axes[i++];
            var a = self.GetInterval(axis);
            var b = triangle.GetInterval(axis);
            if ((b.val_min > a.val_max) || (a.val_min > b.val_max)) {
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
        static direction_dots = array_create(3);
        static position_dots = array_create(3);
        static t = array_create(6);
        
        var size_array = [self.size.x, self.size.y, self.size.z];
        var dir = self.position.Sub(ray.origin);
        
        var dx = dir.x, dy = dir.y, dz = dir.z;
        var ox = self.orientation.x;
        var oy = self.orientation.y;
        var oz = self.orientation.z;
        var rd = ray.direction;
        var rdx = rd.x, rdy = rd.y, rdz = rd.z;
        
        direction_dots[0] = dot_product_3d(ox.x, ox.y, ox.z, rdx, rdy, rdz);
        direction_dots[1] = dot_product_3d(oy.x, oy.y, oy.z, rdx, rdy, rdz);
        direction_dots[2] = dot_product_3d(oz.x, oz.y, oz.z, rdx, rdy, rdz);
        
        position_dots[0] = dot_product_3d(ox.x, ox.y, ox.z, dx, dy, dz);
        position_dots[1] = dot_product_3d(oy.x, oy.y, oy.z, dx, dy, dz);
        position_dots[2] = dot_product_3d(oz.x, oz.y, oz.z, dx, dy, dz);
        
        for (var i = 0; i < 3; i++) {
            var dd = direction_dots[i];
            var pd = position_dots[i];
            var s = size_array[i];
            if (dd == 0) {
                if ((-pd - s) > 0 || (-pd + s) < 0) {
                    return false;
                }
                dd = 0.0001;
            }
            
            t[i * 2 + 0] = (pd + s) / dd;
            t[i * 2 + 1] = (pd - s) / dd;
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
            var contact_normal;
            
            var contact_point = ray.origin.Add(rd.Mul(contact_distance));
            
            for (var i = 0; i < 6; i++) {
                if (contact_distance == t[i]) {
                    switch (i) {
                        case 0: contact_normal = ox; break;
                        case 1: contact_normal = ox.Mul(-1); break;
                        case 2: contact_normal = oy; break;
                        case 3: contact_normal = oy.Mul(-1); break;
                        case 4: contact_normal = oz; break;
                        case 5: contact_normal = oz.Mul(-1); break;
                    }
                }
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
        
        var ps = sphere.position;
        var po = self.position;
        if (ps.x == po.x && ps.y == po.y && ps.z == po.z) return undefined;
        
        var nearest = self.NearestPoint(ps);
        
        if (nearest.x == ps.x && nearest.y == ps.y && nearest.z == ps.z) {
            return undefined;
        }
        
        var dir = sphere.position.Sub(nearest).Normalize();
        return nearest.Add(dir.Mul(sphere.radius));
    };
    
    static NearestPoint = function(vec3) {
        var result = self.position;
        var dir = vec3.Sub(result);
        var dx = dir.x, dy = dir.y, dz = dir.z;
        
        var size_array = [self.size.x, self.size.y, self.size.z];
        var orientation_array = [self.orientation.x, self.orientation.y, self.orientation.z];
        
        for (var i = 0; i < 3; i++) {
            var axis = orientation_array[i];
            var dist = dot_product_3d(dx, dy, dz, axis.x, axis.y, axis.z);
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
        
        var i = 0;
        repeat (8) {
            var vertex = vertices[i++];
            var dot = dot_product_3d(xx, yy, zz, vertex.x, vertex.y, vertex.z);
            imin = min(imin, dot);
            imax = max(imax, dot);
        }
        
        return { val_min: imin, val_max: imax };
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