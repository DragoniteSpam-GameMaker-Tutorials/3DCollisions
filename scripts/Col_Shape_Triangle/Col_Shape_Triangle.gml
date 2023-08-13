function ColTriangle(a, b, c) constructor {
    self.Set(a, b, c);
    
    static Set = function(a, b, c) {
        self.a = a;
        self.b = b;
        self.c = c;
        var diffAB = b.Sub(a);
        var diffAC = c.Sub(a);
        self.property_normal = diffAB.Cross(diffAC).Normalize();
        var dist = self.property_normal.Dot(a);
        self.property_plane = new ColPlane(self.property_normal, dist);
        
        self.property_edge_ab = diffAB;
        self.property_edge_bc = c.Sub(b);
        self.property_edge_ca = a.Sub(c);
        
        self.property_center = a.Add(b).Add(c).Div(3);
        self.property_radius = self.property_center.DistanceTo(a);
        self.property_min = new Vector3(min(a.x, b.x, c.x), min(a.y, b.y, c.y), min(a.z, b.z, c.z));
        self.property_max = new Vector3(max(a.x, b.x, c.x), max(a.y, b.y, c.y), max(a.z, b.z, c.z));
    };
    
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
    
    static CheckOBB = function(obb) {
        return obb.CheckTriangle(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckTriangle(self);
    };
    
    static CheckTriangle = function(triangle) {
        static zero_vector = new Vector3(0, 0, 0);
        
        var p1 = self.property_center;
        var p2 = triangle.property_center;
        if (point_distance_3d(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) >= (self.property_radius + triangle.property_radius)) return false;
        
        // Phase 1: are each of the points of one triangle on the
        // same side of the plane of the other triangle?
        var plane_a = self.property_plane;
        var plane_b = triangle.property_plane;
        
        var paa = plane_a.PlaneEquation(triangle.a);
        var pab = plane_a.PlaneEquation(triangle.b);
        var pac = plane_a.PlaneEquation(triangle.c);
        
        if ((paa * pab) > 0 && (paa * pac) > 0) {
            return false;
        }
        
        var pba = plane_b.PlaneEquation(self.a);
        var pbb = plane_b.PlaneEquation(self.b);
        var pbc = plane_b.PlaneEquation(self.c);
        
        if ((pba * pbb) > 0 && (pba * pbc) > 0) {
            return false;
        }
        
        // Phase 2: are both triangles coplanar?
        if (plane_a.distance == plane_b.distance && abs(plane_a.normal.Dot(plane_b.normal)) == 1) {
            static test_point = new ColPoint(zero_vector);
            
            test_point.position = self.a;
            if (test_point.CheckTriangle(triangle)) return true;
            test_point.position = self.b;
            if (test_point.CheckTriangle(triangle)) return true;
            test_point.position = self.c;
            if (test_point.CheckTriangle(triangle)) return true;
            test_point.position = triangle.a;
            if (test_point.CheckTriangle(triangle)) return true;
            test_point.position = triangle.b;
            if (test_point.CheckTriangle(triangle)) return true;
            test_point.position = triangle.c;
            if (test_point.CheckTriangle(triangle)) return true;
            
            var origin = self.a;
            var norm = self.property_normal;
            var e1 = self.property_edge_ab;
            var e2 = e1.Cross(norm);
            
            var sa = col_project_onto_plane(self.a, origin, norm, e1, e2);
            var sb = col_project_onto_plane(self.b, origin, norm, e1, e2);
            var sc = col_project_onto_plane(self.c, origin, norm, e1, e2);
            
            var oa = col_project_onto_plane(triangle.a, origin, norm, e1, e2);
            var ob = col_project_onto_plane(triangle.b, origin, norm, e1, e2);
            var oc = col_project_onto_plane(triangle.c, origin, norm, e1, e2);
            
            if (col_lines_intersect(sa, sb, oa, ob)) return true;
            if (col_lines_intersect(sa, sb, ob, oc)) return true;
            if (col_lines_intersect(sa, sb, oc, oa)) return true;
            if (col_lines_intersect(sb, sc, oa, ob)) return true;
            if (col_lines_intersect(sb, sc, ob, oc)) return true;
            if (col_lines_intersect(sb, sc, oc, oa)) return true;
            if (col_lines_intersect(sc, sa, oa, ob)) return true;
            if (col_lines_intersect(sc, sa, ob, oc)) return true;
            if (col_lines_intersect(sc, sa, oc, oa)) return true;
            
            return false;
        }
        
        // Phase 3: the regular SAT
        
        // edges of ourself
        var selfAB = self.property_edge_ab;
        var selfBC = self.property_edge_bc;
        var selfCA = self.property_edge_ca;
        // edges of the other triangle
        var otherAB = triangle.property_edge_ab;
        var otherBC = triangle.property_edge_bc;
        var otherCA = triangle.property_edge_ca;
        
        static axes = array_create(11);
        
        // The normals of both triangle, plus each of the edges of 
        // triangle crossed against each of the edges of the other
        axes[0] = self.property_normal;
        axes[1] = triangle.property_normal;
        axes[2] = otherAB.Cross(selfAB);
        axes[3] = otherBC.Cross(selfAB);
        axes[4] = otherCA.Cross(selfAB);
        axes[5] = otherAB.Cross(selfBC);
        axes[6] = otherBC.Cross(selfBC);
        axes[7] = otherCA.Cross(selfBC);
        axes[8] = otherAB.Cross(selfCA);
        axes[9] = otherBC.Cross(selfCA);
        axes[10] = otherCA.Cross(selfCA);
        
        var i = 0;
        repeat (11) {
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
        return mesh.CheckTriangle(self);
    };
    
    static CheckModel = function(model) {
        return model.CheckTriangle(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        static plane_hit_info = new RaycastHitInformation();
        plane_hit_info.Clear();
        
        if (!self.property_plane.CheckRay(ray, plane_hit_info)) {
            return false;
        }
        
        var barycentric = self.Barycentric(plane_hit_info.point);
        
        if ((barycentric.x >= 0 && barycentric.x <= 1) && (barycentric.y >= 0 && barycentric.y <= 1) && (barycentric.z >= 0 && barycentric.z <= 1)) {
            if (plane_hit_info) {
                hit_info.Update(plane_hit_info.distance, self, plane_hit_info.point, plane_hit_info.normal);
            }
            return true;
        }
        
        return false;
    };
    
    static CheckLine = function(line) {
        static hit_info = new RaycastHitInformation();
        hit_info.Clear();
        
        if (self.CheckRay(line.property_ray, hit_info)) {
            return (hit_info.distance <= line.property_length);
        }
        static reverse = new ColLine(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
        reverse.Set(line.finish, line.start.Sub(line.finish));
        if (self.CheckRay(reverse.property_ray, hit_info)) {
            return (hit_info.distance <= reverse.property_length);
        }
        return false;
    };
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        var pt = self.property_center;
        var ps = sphere.position;
        var nearest = self.NearestPoint(ps);
        // you may also wish to just use the normal of the triangle in this case
        if (pt.x == ps.x && pt.y == ps.y && pt.z == ps.z) return undefined;
        
        var offset = ps.Sub(nearest).Normalize().Mul(sphere.radius);
        
        return nearest.Add(offset);
    };
    
    static GetNormal = function() {
        return self.property_normal;
    };
    
    static GetPlane = function() {
        return self.property_plane;
    };
    
    static NearestPoint = function(vec3) {
        static test_point = new ColPoint(new Vector3(0, 0, 0));
        static lineAB = new ColLine(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
        static lineBC = new ColLine(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
        static lineCA = new ColLine(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
        
        var nearest_to_plane = self.property_plane.NearestPoint(vec3);
        
        test_point.position = nearest_to_plane;
        
        if (test_point.CheckTriangle(self)) {
            return nearest_to_plane;
        }
        
        lineAB.start = self.a;
        lineAB.finish = self.b;
        lineBC.start = self.b;
        lineBC.finish = self.c;
        lineCA.start = self.c;
        lineCA.finish = self.a;
        
        var nearest_to_ab = lineAB.NearestPoint(vec3);
        var nearest_to_bc = lineBC.NearestPoint(vec3);
        var nearest_to_ca = lineCA.NearestPoint(vec3);
        
        var vx = vec3.x, vy = vec3.y, vz = vec3.z;
        
        var dist_ab = point_distance_3d(vx, vy, vz, nearest_to_ab.x, nearest_to_ab.y, nearest_to_ab.z);
        var dist_bc = point_distance_3d(vx, vy, vz, nearest_to_bc.x, nearest_to_bc.y, nearest_to_bc.z);
        var dist_ca = point_distance_3d(vx, vy, vz, nearest_to_ca.x, nearest_to_ca.y, nearest_to_ca.z);
        
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
        
        var ab = self.property_edge_ab;
        var ac = self.c.Sub(self.a);
        var bc = self.property_edge_bc;
        var cb = self.b.Sub(self.c);
        var ca = self.property_edge_ca;
        
        var v = ab.Sub(ab.Project(cb));
        var vdpa = dot_product_3d(v.x, v.y, v.z, pa.x, pa.y, pa.z);
        var vdab = dot_product_3d(v.x, v.y, v.z, ab.x, ab.y, ab.z);
        var a = 1 - vdpa / vdab;
        
        v = bc.Sub(bc.Project(ac));
        var vdpb = dot_product_3d(v.x, v.y, v.z, pb.x, pb.y, pb.z);
        var vdbc = dot_product_3d(v.x, v.y, v.z, bc.x, bc.y, bc.z);
        var b = 1 - vdpb / vdbc;
        
        v = ca.Sub(ca.Project(ab));
        var vdpc = dot_product_3d(v.x, v.y, v.z, pc.x, pc.y, pc.z);
        var vdca = dot_product_3d(v.x, v.y, v.z, ca.x, ca.y, ca.z);
        var c = 1 - vdpc / vdca;
        
        return new Vector3(a, b, c);
    };
    
    static GetInterval = function(axis) {
        var ax = axis.x;
        var ay = axis.y;
        var az = axis.z;
        var ada = dot_product_3d(ax, ay, az, self.a.x, self.a.y, self.a.z);
        var adb = dot_product_3d(ax, ay, az, self.b.x, self.b.y, self.b.z);
        var adc = dot_product_3d(ax, ay, az, self.c.x, self.c.y, self.c.z);
        return { val_min: min(ada, adb, adc), val_max: max(ada, adb, adc) };
    };
    
    static GetMin = function() {
        return self.property_min;
    };
    
    static GetMax = function() {
        return self.property_max;
    };
}