function ColAABB(position, half_extents) constructor {
    self.position = position;               // Vec3
    self.half_extents = half_extents;       // Vec3
    
    self.RecalculateProperties();
    
    static SetPosition = function(position) {
        self.position = position;
        self.RecalculateProperties();
        return self;
    };
    
    static SetHalfExtents = function(half_extents) {
        self.half_extents = half_extents;
        self.RecalculateProperties();
        return self;
    };
    
    static RecalculateProperties = function() {
        self.property_min = self.position.Sub(self.half_extents);
        self.property_max = self.position.Add(self.half_extents);
        
        var pmin = self.property_min;
        var pmax = self.property_max;
        
        self.property_vertices = [
            new Vector3(pmin.x, pmax.y, pmax.z),
            new Vector3(pmin.x, pmax.y, pmin.z),
            new Vector3(pmin.x, pmin.y, pmax.z),
            new Vector3(pmin.x, pmin.y, pmin.z),
            new Vector3(pmax.x, pmax.y, pmax.z),
            new Vector3(pmax.x, pmax.y, pmin.z),
            new Vector3(pmax.x, pmin.y, pmax.z),
            new Vector3(pmax.x, pmin.y, pmin.z),
        ];
        
        var vertices = self.property_vertices;
        
        self.property_edges = [
            new ColLine(vertices[0], vertices[1]),
            new ColLine(vertices[0], vertices[2]),
            new ColLine(vertices[1], vertices[3]),
            new ColLine(vertices[2], vertices[3]),
            new ColLine(vertices[4], vertices[5]),
            new ColLine(vertices[4], vertices[6]),
            new ColLine(vertices[5], vertices[7]),
            new ColLine(vertices[6], vertices[7]),
            new ColLine(vertices[0], vertices[4]),
            new ColLine(vertices[1], vertices[5]),
            new ColLine(vertices[2], vertices[6]),
            new ColLine(vertices[3], vertices[7]),
        ];
    };
    
    static DebugDraw = function() {
        static vertex_add_point = function(vbuff, x, y, z, colour) {
            vertex_position_3d(vbuff, x, y, z);
            vertex_normal(vbuff, 0, 0, 1);
            vertex_texcoord(vbuff, 0, 0);
            vertex_colour(vbuff, colour, 1);
        };
        
        var vbuff = vertex_create_buffer();
        vertex_begin(vbuff, obj_camera.format);
        
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y - self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y - self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y + self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y + self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y - self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y - self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y + self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y + self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y - self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y - self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y - self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y + self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y + self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y + self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y + self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y - self.half_extents.y, self.position.z - self.half_extents.z, c_red);
        
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y - self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y - self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y - self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y + self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x + self.half_extents.x, self.position.y + self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y + self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y + self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        vertex_add_point(vbuff, self.position.x - self.half_extents.x, self.position.y - self.half_extents.y, self.position.z + self.half_extents.z, c_red);
        
        
        vertex_end(vbuff);
        vertex_submit(vbuff, pr_linelist, 1);
        vertex_delete_buffer(vbuff);
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckAABB(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckAABB(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckAABB(self);
    };
    
    static CheckAABB = function(aabb) {
        var box_min = self.property_min;
        var box_max = self.property_max;
        var other_min = aabb.property_min;
        var other_max = aabb.property_max;
        return ((box_min.x <= other_max.x) && (box_max.x >= other_min.x) && (box_min.y <= other_max.y) && (box_max.y >= other_min.y) && (box_min.z <= other_max.z) && (box_max.z >= other_min.z));
    };
    
    static CheckPlane = function(plane) {
        var size = self.half_extents;
        var normal = plane.normal;
        var pos = self.position;
        var anorm = normal.Abs();
        var plength = dot_product_3d(anorm.x, anorm.y, anorm.z, size.x, size.y, size.z);
        var ndot = dot_product_3d(normal.x, normal.y, normal.z, pos.x, pos.y, pos.z);
        return (abs(ndot - plane.distance) < plength);
    };
    
    static CheckOBB = function(obb) {
        return obb.CheckAABB(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckAABB(self);
    };
    
    static CheckTriangle = function(triangle) {
        var ab = triangle.property_edge_ab;
        var bc = triangle.property_edge_bc;
        var ca = triangle.property_edge_ca;
         
        static nx = new Vector3(1, 0, 0);
        static ny = new Vector3(0, 1, 0);
        static nz = new Vector3(0, 0, 1);
        
        static axes = [
            nx, ny, nz,
            undefined,
            undefined,
            undefined,
            undefined,
            undefined,
            undefined,
            undefined,
            undefined,
            undefined,
            undefined
        ];
        
        axes[3] = triangle.property_normal;
        axes[4] = nx.Cross(ab);
        axes[5] = nx.Cross(bc);
        axes[6] = nx.Cross(ca);
        axes[7] = ny.Cross(ab);
        axes[8] = ny.Cross(bc);
        axes[9] = ny.Cross(ca);
        axes[10] = nz.Cross(ab);
        axes[11] = nz.Cross(bc);
        axes[12] = nz.Cross(ca);
        
        var i = 0;
        repeat (13) {
            if (!col_overlap_axis(self, triangle, axes[i++])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckAABB(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckAABB(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var box_min = self.property_min;
        var box_max = self.property_max;
        
        var ray_x = (ray.direction.x == 0) ? 0.0001 : ray.direction.x;
        var ray_y = (ray.direction.y == 0) ? 0.0001 : ray.direction.y;
        var ray_z = (ray.direction.z == 0) ? 0.0001 : ray.direction.z;
        
        var t1 = (box_min.x - ray.origin.x) / ray_x;
        var t2 = (box_max.x - ray.origin.x) / ray_x;
        var t3 = (box_min.y - ray.origin.y) / ray_y;
        var t4 = (box_max.y - ray.origin.y) / ray_y;
        var t5 = (box_min.z - ray.origin.z) / ray_z;
        var t6 = (box_max.z - ray.origin.z) / ray_z;
        
        var tmin = max(
            min(t1, t2),
            min(t3, t4),
            min(t5, t6)
        );
        var tmax = min(
            max(t1, t2),
            max(t3, t4),
            max(t5, t6)
        );
        
        if (tmax < 0) return false;
        if (tmin > tmax) return false;
        
        var t = tmax;
        if (tmin > 0) {
            t = tmin;
        }
        
        var contact_point = ray.origin.Add(ray.direction.Mul(t));
        
        var tnormal;
        if (t == t1) tnormal = new Vector3(-1, 0, 0);
        if (t == t2) tnormal = new Vector3(+1, 0, 0);
        if (t == t3) tnormal = new Vector3(0, -1, 0);
        if (t == t4) tnormal = new Vector3(0, +1, 0);
        if (t == t5) tnormal = new Vector3(0, 0, -1);
        if (t == t6) tnormal = new Vector3(0, 0, +1);
        
        if (hit_info) hit_info.Update(t, self, contact_point, tnormal);
        
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
        var box_min = self.property_min;
        var box_max = self.property_max;
        var xx = (vec3.x < box_min.x) ? box_min.x : vec3.x;
        var yy = (vec3.y < box_min.y) ? box_min.y : vec3.y;
        var zz = (vec3.z < box_min.z) ? box_min.z : vec3.z;
        xx = (xx > box_max.x) ? box_max.x : xx;
        yy = (yy > box_max.y) ? box_max.y : yy;
        zz = (zz > box_max.z) ? box_max.z : zz;
        return new Vector3(xx, yy, zz);
    };
    
    static CheckAABBSAT = function(aabb) {
        static axes = [
            new Vector3(1, 0, 0),
            new Vector3(0, 1, 0),
            new Vector3(0, 0, 1)
        ];
        
        for (var i = 0; i < 3; i++) {
            if (!col_overlap_axis(self, aabb, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static GetInterval = function(axis) {
        var vertices = self.property_vertices;
        var ax = axis.x;
        var ay = axis.y;
        var az = axis.z;
        
        var imin = infinity;
        var imax = -infinity;
        
        var i = 0;
        repeat (8) {
            var vertex = vertices[i++];
            var dot = dot_product_3d(ax, ay, az, vertex.x, vertex.y, vertex.z);
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
    
    static CheckFrustum = function(frustum) {
        var planes = frustum.AsArray();
        var is_intersecting_anything = false;
        for (var i = 0, n = array_length(planes); i < n; i++) {
            var r = self.half_extents.Magnitude();
            
            var dist = planes[i].normal.Dot(self.position) + planes[i].distance;
            
            if (dist < -r)
                return EFrustumResults.OUTSIDE;
            
            if (abs(dist) < r)
                is_intersecting_anything = true;
        }
        return is_intersecting_anything ? EFrustumResults.INTERSECTING : EFrustumResults.INSIDE;
    };
}