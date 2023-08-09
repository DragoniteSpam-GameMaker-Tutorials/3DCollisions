function NewColAABBFromMinMax(point_min, point_max) {
    var center_position = point_min.Add(point_max).Div(2);
    var half_size = point_max.Sub(point_min).Div(2).Abs();
    return new ColAABB(center_position, half_size);
}

function NewColRayFromPoints(start, finish) {
    return new ColRay(start, finish.Sub(start));
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

function col_project_onto_plane(vertex, origin, norm, e1, e2) {
    var diff = vertex.Sub(origin);
    return new Vector3(
        dot_product_3d(diff.x, diff.y, diff.z, e1.x, e1.y, e1.z),
        dot_product_3d(diff.x, diff.y, diff.z, e2.x, e2.y, e2.z),
        0
    );
}

function col_lines_intersect(a, b, c, d) {
    return (col_points_are_counterclockwise(a, c, d) != col_points_are_counterclockwise(b, c, d)) &&
        (col_points_are_counterclockwise(a, b, c) != col_points_are_counterclockwise(a, b, d));
}

function col_points_are_counterclockwise(a, b, c) {
    return ((c.y - a.y) * (b.x - a.x)) < ((b.y - a.y) * (c.x - a.x));
}