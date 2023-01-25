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
        
    };
    
    static CheckTriangle = function(triangle) {
        
    };
    
    static CheckMesh = function(mesh) {
        return false;
    };
    
    static CheckModel = function(mesh) {
        return false;
    };
    
    static CheckLine = function(line) {
        var inverse = self.GetTransformMatrix().Inverse();
        
    };
    
    static CheckRay = function(ray, hit_info) {
        var inverse = self.GetTransformMatrix().Inverse();
        
    };
}