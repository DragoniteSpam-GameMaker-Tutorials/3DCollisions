function ColTransformedModel(mesh, position = new Vector3(0, 0, 0), rotation = new Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)) constructor {
    self.mesh = mesh;
    self.position = position;
    self.rotation = rotation;
    
    static GetTransformMatrix = function() {
        return self.rotation.GetRotationMatrix().Mul(self.position.GetTranslationMatrix());
    };
    
    static CheckPoint = function(point) {
        var inverse = self.GetTransformMatrix().Inverse();
        var untransformed = new ColPoint(inverse.MulPoint(point.position));
        return self.mesh.CheckPoint(untransformed);
    };
    
    static CheckSphere = function(sphere) {
        var inverse = self.GetTransformMatrix().Inverse();
        var untransformed = new ColSphere(inverse.MulPoint(sphere.position), sphere.radius);
        return self.mesh.CheckSphere(untransformed);
    };
    
    static CheckAABB = function(aabb) {
        var inverse = self.GetTransformMatrix().Inverse();
        var untransformed = new ColOBB(inverse.MulPoint(aabb.position), aabb.half_extents, inverse.GetOrientationMatrix());
        return self.mesh.CheckOBB(untransformed);
    };
    
    static CheckOBB = function(obb) {
        var inverse = self.GetTransformMatrix().Inverse();
        var untransformed = new ColOBB(inverse.MulPoint(obb.position), obb.size, obb.orientation.Mul(inverse.GetOrientationMatrix()));
        return self.mesh.CheckOBB(untransformed);
    };
    
    static CheckPlane = function(plane) {
        var inverse = self.GetTransformMatrix().Inverse();
        
        var point = plane.normal.Mul(plane.distance);
        point = inverse.MulPoint(point);
        
        var normal = inverse.MulVector(plane.normal);
        var distance = point.Dot(normal);
        
        var untransformed = new ColPlane(normal, distance);
        return self.mesh.CheckPlane(untransformed);
    };
    
    static CheckCapsule = function(capsule) {
        var inverse = self.GetTransformMatrix().Inverse();
        var untransformed = new ColCapsule(inverse.MulPoint(capsule.line.start), inverse.MulPoint(capsule.line.finish), capsule.radius);
        return self.mesh.CheckCapsule(untransformed);
    };
    
    static CheckTriangle = function(triangle) {
        var inverse = self.GetTransformMatrix().Inverse();
        // "homework"
    };
    
    static CheckMesh = function(mesh) {
        return false;
    };
    
    static CheckModel = function(mesh) {
        return false;
    };
    
    static CheckLine = function(line) {
        var inverse = self.GetTransformMatrix().Inverse();
        // "homework"
    };
    
    static CheckRay = function(ray, hit_info) {
        var transform = self.GetTransformMatrix();
        var inverse = transform.Inverse();
        var untransformed = new ColRay(inverse.MulPoint(ray.origin), inverse.MulVector(ray.direction));
        var untransformed_hit_info = new RaycastHitInformation();
        
        if (self.mesh.CheckRay(untransformed, untransformed_hit_info)) {
            var point = transform.MulPoint(untransformed_hit_info.point);
            var normal = transform.MulVector(untransformed_hit_info.normal);
            var distance = ray.origin.DistanceTo(point);
            hit_info.Update(distance, self, point, normal);
            return true;
        }
        
        return false;
    };
    
    static GetMin = function() {
        var transform = self.GetTransformMatrix();
        var obb = new ColOBB(transform.MulPoint(self.mesh.bounds.position), self.mesh.bounds.size, transform.GetOrientationMatrix());
        return obb.GetMin();
    };
    
    static GetMax = function() {
        var transform = self.GetTransformMatrix();
        var obb = new ColOBB(transform.MulPoint(self.mesh.bounds.position), self.mesh.bounds.size, transform.GetOrientationMatrix());
        return obb.GetMax();
    };
}