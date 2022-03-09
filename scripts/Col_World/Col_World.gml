function ColObject(shape, reference) constructor {
    self.shape = shape;
    self.reference = reference;
    
    static CheckObject = function(object) {
        if (object == self) return false;
        return self.shape.CheckObject(object);
    };
    
    static CheckRay = function(ray, hit_info) {
        return self.shape.CheckRay(ray, hit_info);
    };
}