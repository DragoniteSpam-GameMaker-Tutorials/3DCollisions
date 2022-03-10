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

function ColWorldOctree(bounds, depth) constructor {
    self.bounds = bounds;
    self.depth = depth;
    
    self.contents = [];
    self.children = undefined;
    
    static Split = function() {
        if (array_length(self.contents) == 0) return;
        if (self.children != undefined) return;
        
        var center = self.bounds.position;
        var sides = self.bounds.half_extents.Mul(0.5);
        
        self.children = [
            new ColWorldOctree(new ColAABB(center.Add(new Vector3(-sides.x,  sides.y, -sides.z)), sides), self.depth - 1),
            new ColWorldOctree(new ColAABB(center.Add(new Vector3( sides.x,  sides.y, -sides.z)), sides), self.depth - 1),
            new ColWorldOctree(new ColAABB(center.Add(new Vector3(-sides.x,  sides.y,  sides.z)), sides), self.depth - 1),
            new ColWorldOctree(new ColAABB(center.Add(new Vector3( sides.x,  sides.y,  sides.z)), sides), self.depth - 1),
            new ColWorldOctree(new ColAABB(center.Add(new Vector3(-sides.x, -sides.y, -sides.z)), sides), self.depth - 1),
            new ColWorldOctree(new ColAABB(center.Add(new Vector3( sides.x, -sides.y, -sides.z)), sides), self.depth - 1),
            new ColWorldOctree(new ColAABB(center.Add(new Vector3(-sides.x, -sides.y,  sides.z)), sides), self.depth - 1),
            new ColWorldOctree(new ColAABB(center.Add(new Vector3( sides.x, -sides.y,  sides.z)), sides), self.depth - 1),
        ];
        
        for (var i = 0; i < 8; i++) {
            var tree = self.children[i];
            for (var j = 0; j < array_length(self.contents); j++) {
                tree.Add(self.contents[j]);
            }
        }
    };
    
    static Add = function(object) {
        if (!object.shape.CheckAABB(self.bounds)) return;
        for (var i = 0; i < array_length(self.contents); i++) {
            if (self.contents[i] == object) return;
        }
        
        array_push(self.contents, object);
        
        if (self.depth > 0) {
            self.Split();
            
            for (var i = 0; i < array_length(self.children); i++) {
                self.children[i].Add(object);
            }
        }
    };
    
    static Remove = function(object) {
        for (var i = 0; i < array_length(self.contents); i++) {
            if (self.contents[i] == object) {
                array_delete(self.contents, i, 1);
                if (self.depth > 0) {
                    for (var j = 0; j < array_length(self.children); j++) {
                        self.children[j].Remove(object);
                    }
                }
                return;
            }
        }
    };
    
    static CheckObject = function(object) {
        if (!object.shape.CheckAABB(self.bounds)) return;
        
        if (self.children == undefined) {
            for (var i = 0; i < array_length(self.contents); i++) {
                if (self.contents[i].CheckObject(object)) {
                    return true;
                }
            }
        } else {
            for (var i = 0; i < array_length(self.children); i++) {
                if (self.children[i].CheckObject(object)) {
                    return true;
                }
            }
        }
        
        return false;
    };
    
    static CheckRay = function(ray, hit_info) {
        if (!ray.CheckAABB(self.bounds, new RaycastHitInformation())) return;
        
        var result = false;
        if (self.children == undefined) {
            for (var i = 0; i < array_length(self.contents); i++) {
                if (self.contents[i].CheckRay(ray, hit_info)) {
                    result = true;
                }
            }
        } else {
            for (var i = 0; i < array_length(self.children); i++) {
                if (self.children[i].CheckRay(ray, hit_info)) {
                    result = true;
                }
            }
        }
        
        return result;
    };
}