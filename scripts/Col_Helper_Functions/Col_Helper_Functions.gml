function NewColAABBFromMinMax(point_min, point_max) {
    var center_position = point_min.Add(point_max).Div(2);
    var half_size = point_max.Sub(point_min).Div(2).Abs();
    return new ColAABB(center_position, half_size);
}

function NewColRayFromPoints(start, finish) {
    var dir = finish.Sub(start).Normalize();
    return new ColRay(start, dir);
}

function RaycastHitInformation() constructor {
    self.shape = undefined;
    self.point = undefined;
    self.distance = infinity;
    self.normal = undefined;
    
    static Update = function(distance, shape, point, normal) {
        if (distance < self.distance) {
            self.distance = distance;
            self.shape = shape;
            self.point = point;
            self.normal = normal;
        }
    };
    
    static Clear = function() {
        self.shape = undefined;
        self.point = undefined;
        self.distance = infinity;
        self.normal = undefined;
    };
}