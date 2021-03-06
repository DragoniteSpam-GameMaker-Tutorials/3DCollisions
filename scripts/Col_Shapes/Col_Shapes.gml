// Some basic shapes
function ColPoint(position) constructor {
    self.position = position;               // Vec3
    
    static CheckObject = function(object) {
        return object.shape.CheckPoint(self);
    };
    
    static CheckPoint = function(point) {
        return self.position.Equals(point.position);
    };
    
    static CheckSphere = function(sphere) {
        return self.position.DistanceTo(sphere.position) <= sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        var box_min = aabb.GetMin();
        var box_max = aabb.GetMax();
        if (self.position.x < box_min.x || self.position.y < box_min.y || self.position.z < box_min.z) return false;
        if (self.position.x > box_max.x || self.position.y > box_max.y || self.position.z > box_max.z) return false;
        return true;
    };
    
    static CheckPlane = function(plane) {
        var ndot = self.position.Dot(plane.normal);
        return (ndot == plane.distance);
    };
    
    static CheckTriangle = function(triangle) {
        var pa = triangle.a.Sub(self.position);
        var pb = triangle.b.Sub(self.position);
        var pc = triangle.c.Sub(self.position);
        
        var normPBC = pb.Cross(pc).Normalize();
        var normPCA = pc.Cross(pa).Normalize();
        var normPAB = pa.Cross(pb).Normalize();
        
        if (normPBC.Dot(normPCA) < 1) {
            return false;
        }
        
        if (normPBC.Dot(normPAB) < 1) {
            return false;
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckPoint(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var nearest = ray.NearestPoint(self.position);
        if (nearest.DistanceTo(self.position) != 0) return false;
        
        hit_info.Update(self.position.DistanceTo(ray.origin), self, self.position, undefined);
        
        return true;
    };
    
    static CheckLine = function(line) {
        var nearest = line.NearestPoint(self.position);
         return (nearest.DistanceTo(self.position) == 0);
    };
}

function ColSphere(position, radius) constructor {
    self.position = position;               // Vec3
    self.radius = radius;                   // Vec3
    
    static CheckObject = function(object) {
        return object.shape.CheckSphere(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckSphere(self);
    };
    
    static CheckSphere = function(sphere) {
        return self.position.DistanceTo(sphere.position) <= (self.radius + sphere.radius);
    };
    
    static CheckAABB = function(aabb) {
        var nearest = aabb.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist <= self.radius;
    };
    
    static CheckPlane = function(plane) {
        var nearest = plane.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist <= self.radius;
    };
    
    static CheckTriangle = function(triangle) {
        var nearest = triangle.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist <= self.radius;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckSphere(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var e = self.position.Sub(ray.origin);
        var mag_squared = power(e.Magnitude(), 2);
        var r_squared = power(self.radius, 2);
        var EdotD = e.Dot(ray.direction);
        var offset = r_squared - (mag_squared - (EdotD * EdotD));
        if (offset < 0) return false;
        
        var f = sqrt(abs(offset));
        var t = EdotD - f;
        if (mag_squared < r_squared) {
            t = EdotD + f;
        }
        var contact_point = ray.origin.Add(ray.direction.Mul(t));
        
        hit_info.Update(t, self, contact_point, contact_point.Sub(self.position).Normalize());
        
        return true;
    };
    
    static CheckLine = function(line) {
        var nearest = line.NearestPoint(self.position);
        var dist = nearest.DistanceTo(self.position);
        return dist <= self.radius;
    };
    
    static NearestPoint = function(vec3) {
        var dist = vec3.Sub(self.position).Normalize();
        var scaled_dist = dist.Mul(self.radius);
        return scaled_dist.Add(self.position);
    };
}

function ColAABB(position, half_extents) constructor {
    self.position = position;               // Vec3
    self.half_extents = half_extents;       // Vec3
    
    static DebugDraw = function() {
        static vertex_add_point = function(vbuff, x, y, z, colour) {
            vertex_position_3d(vbuff, x, y, z);
            vertex_normal(vbuff, 0, 0, 1);
            vertex_colour(vbuff, colour, 1);
        };
        
        var vbuff = vertex_create_buffer();
        vertex_begin(vbuff, obj_demo.vertex_format);
        
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
        var box_min = self.GetMin();
        var box_max = self.GetMax();
        var other_min = aabb.GetMin();
        var other_max = aabb.GetMax();
        return ((box_min.x <= other_max.x) && (box_max.x >= other_min.x) && (box_min.y <= other_max.y) && (box_max.y >= other_min.y) && (box_min.z <= other_max.z) && (box_max.z >= other_min.z));
    };
    
    static CheckPlane = function(plane) {
        var anorm = plane.normal.Abs();
        var plength = self.half_extents.Dot(anorm);
        var ndot = plane.normal.Dot(self.position);
        var dist = ndot - plane.distance;
        return (abs(dist) <= plength);
    };
    
    static CheckTriangle = function(triangle) {
        var ab = triangle.b.Sub(triangle.a);
        var bc = triangle.c.Sub(triangle.b);
        var ca = triangle.a.Sub(triangle.c);
        
        var nx = new Vector3(1, 0, 0);
        var ny = new Vector3(0, 1, 0);
        var nz = new Vector3(0, 0, 1);
        
        var axes = [
            nx,
            ny,
            nz,
            triangle.GetNormal(),
            nx.Cross(ab),
            nx.Cross(bc),
            nx.Cross(ca),
            ny.Cross(ab),
            ny.Cross(bc),
            ny.Cross(ca),
            nz.Cross(ab),
            nz.Cross(bc),
            nz.Cross(ca),
        ];
        
        for (var i = 0; i < 13; i++) {
            if (!col_overlap_axis(self, triangle, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckAABB(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var box_min = self.GetMin();
        var box_max = self.GetMax();
        
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
        
        hit_info.Update(t, self, contact_point, tnormal);
        
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
    
    static GetMin = function() {
        return self.position.Sub(self.half_extents);
    };
    
    static GetMax = function() {
        return self.position.Add(self.half_extents);
    };
    
    static NearestPoint = function(vec3) {
        var box_min = self.GetMin();
        var box_max = self.GetMax();
        var xx = (vec3.x < box_min.x) ? box_min.x : vec3.x;
        var yy = (vec3.y < box_min.y) ? box_min.y : vec3.y;
        var zz = (vec3.z < box_min.z) ? box_min.z : vec3.z;
        xx = (xx > box_max.x) ? box_max.x : xx;
        yy = (yy > box_max.y) ? box_max.y : yy;
        zz = (zz > box_max.z) ? box_max.z : zz;
        return new Vector3(xx, yy, zz);
    };
    
    static CheckAABBSAT = function(aabb) {
        var axes = [
            new Vector3(1, 0, 0),
            new Vector3(0, 1, 0),
            new Vector3(0, 0, 1),
        ];
        
        for (var i = 0; i < 3; i++) {
            if (!col_overlap_axis(self, aabb, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static GetInterval = function(axis) {
        var pmin = self.GetMin();
        var pmax = self.GetMax();
        
        var vertices = [
            new Vector3(pmin.x, pmin.y, pmin.z),
            new Vector3(pmin.x, pmin.y, pmax.z),
            new Vector3(pmin.x, pmax.y, pmin.z),
            new Vector3(pmin.x, pmax.y, pmax.z),
            new Vector3(pmax.x, pmin.y, pmin.z),
            new Vector3(pmax.x, pmin.y, pmax.z),
            new Vector3(pmax.x, pmax.y, pmin.z),
            new Vector3(pmax.x, pmax.y, pmax.z),
        ];
        
        var imin = axis.Dot(vertices[0]);
        var imax = imin;
        
        for (var i = 1; i < 8; i++) {
            var dot = axis.Dot(vertices[i]);
            imin = min(imin, dot);
            imax = max(imax, dot);
        }
        
        return new ColInterval(imin, imax);
    };
}

function ColPlane(normal, distance) constructor {
    self.normal = normal.Normalize();       // Vec3
    self.distance = distance;               // number
    
    static CheckObject = function(object) {
        return object.shape.CheckPlane(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckPlane(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckPlane(self);
    };
    
    static CheckAABB = function(aabb) {
        return aabb.CheckPlane(self);
    };
    
    static CheckPlane = function(plane) {
        var cross = self.normal.Cross(plane.normal);
        return (cross.Magnitude() > 0) || (self.distance == plane.distance);
    };
    
    static CheckTriangle = function(triangle) {
        var side_a = self.PlaneEquation(triangle.a);
        var side_b = self.PlaneEquation(triangle.b);
        var side_c = self.PlaneEquation(triangle.c);
        
        if (side_a == 0 && side_b == 0 && side_c == 0) {
            return true;
        }
        
        if (sign(side_a) == sign(side_b) && sign(side_a) == sign(side_c)) {
            return false;
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckPlane(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var DdotN = ray.direction.Dot(self.normal);
        if (DdotN >= 0) return false;
        
        var OdotN = ray.origin.Dot(self.normal);
        var t = (self.distance - OdotN) / DdotN;
        if (t < 0) return false;
        
        var contact_point = ray.origin.Add(ray.direction.Mul(t));
        
        hit_info.Update(t, self, contact_point, self.normal);
        
        return true;
    };
    
    static CheckLine = function(line) {
        var dir = line.finish.Sub(line.start);
        var NdotS = self.normal.Dot(line.start);
        var NdotD = self.normal.Dot(dir);
        
        if (NdotD == 0) return false;
        var t = (self.distance - NdotS) / NdotD;
        return (t >= 0) && (t <= 1);
    };
    
    static NearestPoint = function(vec3) {
        var ndot = self.normal.Dot(vec3);
        var dist = ndot - self.distance;
        var scaled_dist = self.normal.Mul(dist);
        return vec3.Sub(scaled_dist);
    };
    
    static PlaneEquation = function(vec3) {
        // much like the dot product, this function will return:
        // - +1ish if the value is in front of the plane
        // - 0 if the value is on the plane
        // - -1ish is the value is behind the plane
        var dot = vec3.Dot(self.normal);
        return dot - self.distance;
    };
}

function ColTriangle(a, b, c) constructor {
    self.a = a;
    self.b = b;
    self.c = c;
    
    static CheckObject = function(object) {
        return object.shape.CheckTriangle(self);
    };
    
    static CheckPoint = function(point) {
        return point.CheckTriangle(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckTriangle(self);
    };
    
    static CheckAABB = function(aabb) {
        return aabb.CheckTriangle(self);
    };
    
    static CheckPlane = function(plane) {
        return plane.CheckTriangle(self);
    };
    
    static CheckTriangle = function(triangle) {
        // Phase 1: are each of the points of one triangle on the
        // same side of the plane of the other triangle?
        var plane_a = self.GetPlane();
        var plane_b = triangle.GetPlane();
        
        var paa = plane_a.PlaneEquation(triangle.a);
        var pab = plane_a.PlaneEquation(triangle.b);
        var pac = plane_a.PlaneEquation(triangle.c);
        
        var pba = plane_b.PlaneEquation(self.a);
        var pbb = plane_b.PlaneEquation(self.b);
        var pbc = plane_b.PlaneEquation(self.c);
        
        if ((paa * pab) > 0 && (paa * pac) > 0) {
            return false;
        }
        
        if ((pba * pbb) > 0 && (pba * pbc) > 0) {
            return false;
        }
        
        // Phase 2: are both triangles coplanar?
        if (plane_a.distance == plane_b.distance && abs(plane_a.normal.Dot(plane_b.normal)) == 1) {
            if (new ColPoint(self.a).CheckTriangle(triangle)) return true;
            if (new ColPoint(self.b).CheckTriangle(triangle)) return true;
            if (new ColPoint(self.c).CheckTriangle(triangle)) return true;
            if (new ColPoint(triangle.a).CheckTriangle(self)) return true;
            if (new ColPoint(triangle.b).CheckTriangle(self)) return true;
            if (new ColPoint(triangle.c).CheckTriangle(self)) return true;
            
            var origin = self.a;
            var norm = self.GetNormal();
            var e1 = self.b.Sub(self.a);
            var e2 = e1.Cross(norm);
            
            var self_projected = new ColTriangle(
                col_project_onto_plane(self.a, origin, norm, e1, e2),
                col_project_onto_plane(self.b, origin, norm, e1, e2),
                col_project_onto_plane(self.c, origin, norm, e1, e2),
            );
            
            var other_projected = new ColTriangle(
                col_project_onto_plane(triangle.a, origin, norm, e1, e2),
                col_project_onto_plane(triangle.b, origin, norm, e1, e2),
                col_project_onto_plane(triangle.c, origin, norm, e1, e2),
            );
            
            if (col_lines_intersect(self_projected.a, self_projected.b, other_projected.a, other_projected.b)) return true;
            if (col_lines_intersect(self_projected.a, self_projected.b, other_projected.b, other_projected.c)) return true;
            if (col_lines_intersect(self_projected.a, self_projected.b, other_projected.c, other_projected.a)) return true;
            if (col_lines_intersect(self_projected.b, self_projected.c, other_projected.a, other_projected.b)) return true;
            if (col_lines_intersect(self_projected.b, self_projected.c, other_projected.b, other_projected.c)) return true;
            if (col_lines_intersect(self_projected.b, self_projected.c, other_projected.c, other_projected.a)) return true;
            if (col_lines_intersect(self_projected.c, self_projected.a, other_projected.a, other_projected.b)) return true;
            if (col_lines_intersect(self_projected.c, self_projected.a, other_projected.b, other_projected.c)) return true;
            if (col_lines_intersect(self_projected.c, self_projected.a, other_projected.c, other_projected.a)) return true;
            
            return false;
        }
        
        // Phase 3: the regular SAT
        
        // edges of ourself
        var selfAB = self.b.Sub(self.a);
        var selfBC = self.c.Sub(self.b);
        var selfCA = self.a.Sub(self.c);
        // edges of the other triangle
        var otherAB = triangle.b.Sub(triangle.a);
        var otherBC = triangle.c.Sub(triangle.b);
        var otherCA = triangle.a.Sub(triangle.c);
        
        // The normals of both triangle, plus each of the edges of 
        // triangle crossed against each of the edges of the other
        var axes = [
            self.GetNormal(),
            triangle.GetNormal(),
            otherAB.Cross(selfAB),
            otherBC.Cross(selfAB),
            otherCA.Cross(selfAB),
            otherAB.Cross(selfBC),
            otherBC.Cross(selfBC),
            otherCA.Cross(selfBC),
            otherAB.Cross(selfCA),
            otherBC.Cross(selfCA),
            otherCA.Cross(selfCA),
        ];
        
        for (var i = 0; i < 11; i++) {
            if (!col_overlap_axis(self, triangle, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckTriangle(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        var plane = self.GetPlane();
        var plane_hit_info = new RaycastHitInformation();
        if (!plane.CheckRay(ray, plane_hit_info)) {
            return false;
        }
        
        var result = plane_hit_info.point;
        var barycentric = self.Barycentric(result);
        
        if ((barycentric.x >= 0 && barycentric.x <= 1) && (barycentric.y >= 0 && barycentric.y <= 1) && (barycentric.z >= 0 && barycentric.z <= 1)) {
            hit_info.Update(plane_hit_info.distance, self, result, plane_hit_info.normal);
            return true;
        }
        
        return false;
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
    
    static GetNormal = function() {
        var diffAB = self.b.Sub(self.a);
        var diffAC = self.c.Sub(self.a);
        return diffAB.Cross(diffAC).Normalize();
    };
    
    static GetPlane = function() {
        var norm = self.GetNormal();
        var dist = norm.Dot(self.a);
        return new ColPlane(norm, dist);
    };
    
    static NearestPoint = function(vec3) {
        var plane = self.GetPlane();
        var nearest_to_plane = plane.NearestPoint(vec3);
        
        if (self.CheckPoint(new ColPoint(nearest_to_plane))) {
            return nearest_to_plane;
        }
        
        var lineAB = new ColLine(self.a, self.b);
        var lineBC = new ColLine(self.b, self.c);
        var lineCA = new ColLine(self.c, self.a);
        
        var nearest_to_ab = lineAB.NearestPoint(vec3);
        var nearest_to_bc = lineBC.NearestPoint(vec3);
        var nearest_to_ca = lineCA.NearestPoint(vec3);
        
        var dist_ab = vec3.DistanceTo(nearest_to_ab);
        var dist_bc = vec3.DistanceTo(nearest_to_bc);
        var dist_ca = vec3.DistanceTo(nearest_to_ca);
        
        if (dist_ab < dist_bc && dist_ab < dist_ca) {
            return nearest_to_ab;
        }
        
        if (dist_bc < dist_ca && dist_bc < dist_ab) {
            return nearest_to_bc;
        }
        
        return nearest_to_ca;
    };
    
    static Barycentric = function(vec3) {
        var pa = vec3.Sub(self.a);
        var pb = vec3.Sub(self.b);
        var pc = vec3.Sub(self.c);
        
        var ab = self.b.Sub(self.a);
        var ac = self.c.Sub(self.a);
        var bc = self.c.Sub(self.b);
        var cb = self.b.Sub(self.c);
        var ca = self.a.Sub(self.c);
        
        var v = ab.Sub(ab.Project(cb));
        var a = 1 - (v.Dot(pa) / v.Dot(ab));
        
        v = bc.Sub(bc.Project(ac));
        var b = 1 - (v.Dot(pb) / v.Dot(bc));
        
        v = ca.Sub(ca.Project(ab));
        var c = 1 - (v.Dot(pc) / v.Dot(ca));
        
        return new Vector3(a, b, c);
    };
    
    static GetInterval = function(axis) {
        var imin = min(axis.Dot(self.a), axis.Dot(self.b), axis.Dot(self.c));
        var imax = max(axis.Dot(self.a), axis.Dot(self.b), axis.Dot(self.c));
        return new ColInterval(imin, imax);
    };
}

function ColMesh(triangle_array) constructor {
    self.triangles = triangle_array;
    
    var bounds_min = new Vector3(infinity, infinity, infinity);
    var bounds_max = new Vector3(-infinity, -infinity, -infinity);
    
    for (var i = 0; i < array_length(triangle_array); i++) {
        var tri = triangle_array[i];
        bounds_min.x = min(bounds_min.x, tri.a.x, tri.b.x, tri.c.x);
        bounds_min.y = min(bounds_min.y, tri.a.y, tri.b.y, tri.c.y);
        bounds_min.z = min(bounds_min.z, tri.a.z, tri.b.z, tri.c.z);
        bounds_max.x = max(bounds_max.x, tri.a.x, tri.b.x, tri.c.x);
        bounds_max.y = max(bounds_max.y, tri.a.y, tri.b.y, tri.c.y);
        bounds_max.z = max(bounds_max.z, tri.a.z, tri.b.z, tri.c.z);
    }
    
    self.bounds = NewColAABBFromMinMax(bounds_min, bounds_max);
    
    self.accelerator = new ColOctree(self.bounds, self);
    self.accelerator.triangles = triangle_array;
    self.accelerator.Split(3);
    
    static CheckObject = function(object) {
        return object.shape.CheckMesh(self);
    };
    
    static CheckGeneral = function(shape) {
        var process_these = [self.accelerator];
        
        while (array_length(process_these) > 0) {
            var tree = process_these[0];
            array_delete(process_these, 0, 1);
            
            if (tree.children == undefined) {
                for (var i = 0; i < array_length(tree.triangles); i++) {
                    if (shape.CheckTriangle(tree.triangles[i])) {
                        return true;
                    }
                }
            } else {
                for (var i = 0; i < 8; i++) {
                    if (shape.CheckAABB(tree.children[i].bounds)) {
                        array_push(process_these, tree.children[i]);
                    }
                }
            }
        }
        
        return false;
    };
    
    static CheckPoint = function(point) {
        return self.CheckGeneral(point);
    };
    
    static CheckSphere = function(sphere) {
        return self.CheckGeneral(sphere);
    };
    
    static CheckAABB = function(aabb) {
        return self.CheckGeneral(aabb);
    };
    
    static CheckPlane = function(plane) {
        return self.CheckGeneral(plane);
    };
    
    static CheckTriangle = function(triangle) {
        return self.CheckGeneral(triangle);
    };
    
    static CheckMesh = function(mesh) {
        return self.CheckGeneral(mesh);
    };
    
    static CheckRay = function(ray, hit_info) {
        var process_these = [self.accelerator];
        var dummy_hit_info = new RaycastHitInformation();
        var hit_detected = false;
        
        while (array_length(process_these) > 0) {
            var tree = process_these[0];
            array_delete(process_these, 0, 1);
            
            if (tree.children == undefined) {
                for (var i = 0; i < array_length(tree.triangles); i++) {
                    if (ray.CheckTriangle(tree.triangles[i], hit_info)) {
                        hit_detected = true;
                    }
                }
            } else {
                for (var i = 0; i < 8; i++) {
                    if (ray.CheckAABB(tree.children[i].bounds, dummy_hit_info)) {
                        array_push(process_these, tree.children[i]);
                    }
                }
            }
        }
        
        return hit_detected;
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
}

// Line "shapes"
function ColRay(origin, direction) constructor {
    self.origin = origin;                   // Vec3
    self.direction = direction.Normalize(); // Vec3
    
    static CheckPoint = function(point, hit_info) {
        return point.CheckRay(self, hit_info);
    };
    
    static CheckSphere = function(sphere, hit_info) {
        return sphere.CheckRay(self, hit_info);
    };
    
    static CheckAABB = function(aabb, hit_info) {
        return aabb.CheckRay(self, hit_info);
    };
    
    static CheckPlane = function(plane, hit_info) {
        return plane.CheckRay(self, hit_info);
    };
    
    static CheckTriangle = function(triangle, hit_info) {
        return triangle.CheckRay(self, hit_info);
    };
    
    static CheckMesh = function(mesh, hit_info) {
        return mesh.CheckRay(self, hit_info);
    };
    
    static CheckRay = function(ray, hit_info) {
        return false;
    };
    
    static CheckLine = function(line, hit_info) {
        return false;
    };
    
    static NearestPoint = function(vec3) {
        var diff = vec3.Sub(self.origin);
        var t = max(diff.Dot(self.direction), 0);
        var scaled_dir = self.direction.Mul(t);
        return self.origin.Add(scaled_dir);
    };
}

function ColLine(start, finish) constructor {
    self.start = start;                     // Vec3
    self.finish = finish;                   // Vec3
    
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
    
    static CheckTriangle = function(triangle) {
        return triangle.CheckLine(self);
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckLine(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        return false;
    };
    
    static CheckLine = function(line) {
        return false;
    };
    
    static Length = function() {
        return self.start.DistanceTo(self.finish);
    };
    
    static NearestPoint = function(vec3) {
        var line_vec = self.finish.Sub(self.start);
        var point_vec = vec3.Sub(self.start);
        var t = clamp(point_vec.Dot(line_vec) / line_vec.Dot(line_vec), 0, 1);
        var scaled_vec = line_vec.Mul(t);
        return self.start.Add(scaled_vec);
    };
}