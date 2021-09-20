// Some basic shapes
function ColPoint(position) constructor {
    self.position = position;               // Vec3
    
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
    
    static CheckPoint = function(point) {
        return point.CheckTriangle(self);
    };
    
    static CheckSphere = function(sphere) {
        return sphere.CheckTriangle(self);
    };
    
    static CheckAABB = function(aabb) {
        
    };
    
    static CheckPlane = function(plane) {
        
    };
    
    static CheckTriangle = function(triangle) {
        
    };
    
    static CheckRay = function(ray, hit_info) {
        
    };
    
    static CheckLine = function(line) {
        
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