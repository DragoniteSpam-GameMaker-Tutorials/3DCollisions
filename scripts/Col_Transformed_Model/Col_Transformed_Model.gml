function ColTransformedModel(mesh, position = new Vector3(0, 0, 0), rotation = new Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)) constructor {
    self.mesh = mesh;
    self.position = position;
    self.rotation = rotation;
    
    self.RecalculateProperties();
    
    static SetMesh = function(mesh) {
        self.mesh = mesh;
        self.RecalculateProperties();
        return self;
    };
    
    static SetPosition = function(position) {
        self.position = position;
        self.RecalculateProperties();
        return self;
    };
    
    static SetRotation = function(rotation) {
        self.rotation = rotation;
        self.RecalculateProperties();
        return self;
    };
    
    static RecalculateProperties = function() {
        self.property_transform = self.rotation.GetRotationMatrix().Mul(self.position.GetTranslationMatrix());
        self.property_inverse = self.property_transform.Inverse();
        
        var obb = new ColOBB(self.property_transform.MulPoint(self.mesh.bounds.position), self.mesh.bounds.half_extents, self.property_transform.GetOrientationMatrix());
        self.property_min = obb.property_min;
        self.property_max = obb.property_max;
    };
    
    static GetTransformMatrix = function() {
        return self.property_transform;
    };
    
    static CheckPoint = function(point) {
        var inverse = self.property_inverse;
        var untransformed = new ColPoint(inverse.MulPoint(point.position));
        return self.mesh.CheckPoint(untransformed);
    };
    
    static CheckSphere = function(sphere) {
        var inverse = self.property_inverse;
        var untransformed = new ColSphere(inverse.MulPoint(sphere.position), sphere.radius);
        return self.mesh.CheckSphere(untransformed);
    };
    
    static CheckAABB = function(aabb) {
        var inverse = self.property_inverse;
        var untransformed = new ColOBB(inverse.MulPoint(aabb.position), aabb.half_extents, inverse.GetOrientationMatrix());
        return self.mesh.CheckOBB(untransformed);
    };
    
    static CheckOBB = function(obb) {
        var inverse = self.property_inverse;
        var untransformed = new ColOBB(inverse.MulPoint(obb.position), obb.size, obb.orientation.Mul(inverse.GetOrientationMatrix()));
        return self.mesh.CheckOBB(untransformed);
    };
    
    static CheckPlane = function(plane) {
        var inverse = self.property_inverse;
        
        var point = plane.normal.Mul(plane.distance);
        point = inverse.MulPoint(point);
        
        var normal = inverse.MulVector(plane.normal);
        var distance = point.Dot(normal);
        
        var untransformed = new ColPlane(normal, distance);
        return self.mesh.CheckPlane(untransformed);
    };
    
    static CheckCapsule = function(capsule) {
        var inverse = self.property_inverse;
        var untransformed = new ColCapsule(inverse.MulPoint(capsule.line.start), inverse.MulPoint(capsule.line.finish), capsule.radius);
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
        untransformed_hit_info.Clear();
        
        var transform = self.property_transform;
        var inverse = self.property_inverse;
        var untransformed = new ColRay(inverse.MulPoint(ray.origin), inverse.MulVector(ray.direction));
        
        if (self.mesh.CheckRay(untransformed, untransformed_hit_info)) {
            var point = transform.MulPoint(untransformed_hit_info.point);
            var normal = transform.MulVector(untransformed_hit_info.normal);
            var distance = ray.origin.DistanceTo(point);
            hit_info.Update(distance, self, point, normal);
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