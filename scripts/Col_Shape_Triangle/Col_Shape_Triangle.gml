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
    
    static CheckOBB = function(obb) {
        return obb.CheckTriangle(self);
    };
    
    static CheckCapsule = function(capsule) {
        return capsule.CheckTriangle(self);
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
    
    static CheckModel = function(model) {
        return model.CheckTriangle(self);
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
    
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        var nearest = self.NearestPoint(sphere.position);
        
        // you may wish to just use the normal of the triangle in this case
        if (nearest.DistanceTo(sphere.position) == 0) return undefined;
        
        var dir = sphere.position.Sub(nearest).Normalize();
        var offset = dir.Mul(sphere.radius);
        
        return nearest.Add(offset);
    };
    /*
    static DisplaceSphere = function(sphere) {
        if (!self.CheckSphere(sphere)) return undefined;
        
        var nearest = self.NearestPoint(sphere.position);
        var offset = self.GetNormal().Mul(sphere.radius);
        
        return nearest.Add(offset);
    };
    */
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
    
    static GetMin = function() {
        return new Vector3(min(self.a.x, self.b.x, self.c.x), min(self.a.y, self.b.y, self.c.y), min(self.a.z, self.b.z, self.c.z));
    };
    
    static GetMax = function() {
        return new Vector3(max(self.a.x, self.b.x, self.c.x), max(self.a.y, self.b.y, self.c.y), max(self.a.z, self.b.z, self.c.z));
    };
}