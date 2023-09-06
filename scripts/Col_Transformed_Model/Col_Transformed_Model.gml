function ColTransformedModel(mesh, position = new Vector3(0, 0, 0), rotation = new Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)) constructor {
    self.Set(mesh, position, rotation);
    
    static Set = function(mesh = self.mesh, position = self.position, rotation = self.rotation) {
        self.mesh = mesh;
        self.position = position;
        self.rotation = rotation;
        
        self.property_transform = rotation.GetRotationMatrix().Mul(position.GetTranslationMatrix());
        self.property_inverse = mat4_inverse(self.property_transform);
        
        var obb = new ColOBB(mat4_mul_point(self.property_transform, mesh.bounds.position), mesh.bounds.half_extents, self.property_transform.GetOrientationMatrix());
        self.property_min = obb.property_min;
        self.property_max = obb.property_max;
    };
    
    static GetTransformMatrix = function() {
        return self.property_transform;
    };
    
    static CheckPoint = function(point) {
        var untransformed = new ColPoint(mat4_mul_point(self.property_inverse, point.position));
        return self.mesh.CheckPoint(untransformed);
    };
    
    static CheckSphere = function(sphere) {
        var untransformed = new ColSphere(mat4_mul_point(self.property_inverse, sphere.position), sphere.radius);
        return self.mesh.CheckSphere(untransformed);
    };
    
    static CheckAABB = function(aabb) {
        var untransformed = new ColOBB(mat4_mul_point(self.property_inverse, aabb.position), aabb.half_extents, self.property_inverse.GetOrientationMatrix());
        return self.mesh.CheckOBB(untransformed);
    };
    
    static CheckOBB = function(obb) {
        var untransformed = new ColOBB(mat4_mul_point(self.property_inverse, obb.position), obb.size, obb.orientation.Mul(self.property_inverse.GetOrientationMatrix()));
        return self.mesh.CheckOBB(untransformed);
    };
    
    static CheckPlane = function(plane) {
        var point = plane.normal.Mul(plane.distance);
        point = mat4_mul_point(self.property_inverse, point);
        
        var normal = mat4_mul_vector(self.property_inverse, plane.normal);
        var distance = point.Dot(normal);
        
        var untransformed = new ColPlane(normal, distance);
        return self.mesh.CheckPlane(untransformed);
    };
    
    static CheckCapsule = function(capsule) {
        var untransformed = new ColCapsule(mat4_mul_point(self.property_inverse, capsule.line.start), mat4_mul_point(self.property_inverse, capsule.line.finish), capsule.radius);
        return self.mesh.CheckCapsule(untransformed);
    };
    
    static CheckTriangle = function(triangle) {
        var inverse = self.property_inverse;
        // "homework"
    };
    
    static CheckMesh = function(mesh) {
        return false;
    };
    
    static CheckModel = function(mesh) {
        return false;
    };
    
    static CheckLine = function(line) {
        var inverse = self.property_inverse;
        // "homework"
    };
    
    static CheckRay = function(ray, hit_info) {
        static untransformed_hit_info = new RaycastHitInformation();
        untransformed_hit_info.distance = infinity;
        
        var untransformed = new ColRay(mat4_mul_point(self.property_inverse, ray.origin), mat4_mul_vector(self.property_inverse, ray.direction));
        
        if (self.mesh.CheckRay(untransformed, untransformed_hit_info)) {
            if (hit_info) {
                var point = mat4_mul_point(self.property_transform, untransformed_hit_info.point);
                var normal = mat4_mul_vector(self.property_transform, untransformed_hit_info.normal);
                var distance = point_distance_3d(ray.origin.x, ray.origin.y, ray.origin.z, point.x, point.y, point.z);
                hit_info.Update(distance, self, point, normal);
            }
            return true;
        }
        
        return false;
    };
    
    static DisplaceSphere = function(sphere) {
        return undefined;
    };
    
    static GetMin = function() {
        return self.property_min;
    };
    
    static GetMax = function() {
        return self.property_max;
    };
}