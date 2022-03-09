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

function ColWorld(bounds_min, bounds_max, max_depth) constructor {
    self.bounds = NewColAABBFromMinMax(bounds_min, bounds_max);
    self.accelerator = new ColWorldNode();
    self.depth = max_depth;
    
    static Add = function(object) {
        
    };
    
    static Remove = function(object) {
        
    };
    
    static Update = function(object) {
        self.Remove(object);
        self.Add(object);
    };
    
    static CheckObject = function(object) {
        
    };
    
    static CheckRay = function(ray) {
    };
}