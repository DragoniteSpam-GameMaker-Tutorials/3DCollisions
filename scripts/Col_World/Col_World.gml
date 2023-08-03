function ColObject(shape, reference, mask = 1, group = 1) constructor {
    self.shape = shape;
    self.reference = reference;
    self.mask = mask;                                   // what other objects can collide with me
    self.group = group;                                 // what masks i can detect collisions with
    
    static CheckObject = function(object) {
        if (object == self) return false;
        if ((self.mask & object.group) == 0) return false;
        return self.shape.CheckObject(object);
    };
    
    static CheckRay = function(ray, hit_info, group = 1) {
        if ((self.mask & group) == 0) return false;
        return self.shape.CheckRay(ray, hit_info);
    };
    
    static DisplaceSphere = function(sphere) {
        return self.shape.DisplaceSphere(sphere);
    };
    
    static GetMin = function() {
        return self.shape.GetMin();
    };
    
    static GetMax = function() {
        return self.shape.GetMax();
    };
}

function ColWorld(bounds_min, bounds_max, max_depth) constructor {
    self.bounds = NewColAABBFromMinMax(bounds_min, bounds_max);
    self.accelerator = new ColWorldQuadtree(self.bounds, max_depth);
    self.depth = max_depth;
    
    static Add = function(object) {
        self.accelerator.Add(object);
    };
    
    static Remove = function(object) {
        self.accelerator.Remove(object);
    };
    
    static Update = function(object) {
        self.Remove(object);
        self.Add(object);
    };
    
    static CheckObject = function(object) {
        return self.accelerator.CheckObject(object);
    };
    
    static CheckRay = function(ray, group = 1) {
        var hit_info = new RaycastHitInformation();
        
        if (self.accelerator.CheckRay(ray, hit_info, group)) {
            return hit_info;
        }
        
        return undefined;
    };
    
    static DisplaceSphere = function(sphere_object, attempts = 5) {
        var current_position = sphere_object.shape.position;
        
        repeat (attempts) {
            var collided_with = self.CheckObject(sphere_object);
            if (collided_with == undefined) break;
            
            var displaced_position = collided_with.DisplaceSphere(sphere_object.shape);
            if (displaced_position == undefined) break;
            
            sphere_object.shape.position = displaced_position;
        }
        
        var displaced_position = sphere_object.shape.position;
        sphere_object.shape.position = current_position;
        
        if (current_position == displaced_position) return undefined;
        
        return displaced_position;
    };
    
    static GetObjectsInFrustum = function(frustum) {
        var output = [];
        self.accelerator.GetObjectsInFrustum(frustum, output);
        // if gamemaker ever fixes array_unique, use that here for a minor performance gain
        return output;
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
        var index = array_get_index(self.contents, object);
        if (index != -1) {
            array_delete(self.contents, index, 1);
            for (var j = 0; j < array_length(self.children); j++) {
                self.children[j].Remove(object);
            }
        }
    };
    
    static CheckObject = function(object) {
        if (!object.shape.CheckAABB(self.bounds)) return;
        
        if (self.children == undefined) {
            for (var i = 0; i < array_length(self.contents); i++) {
                if (self.contents[i].CheckObject(object)) {
                    return self.contents[i];
                }
            }
        } else {
            for (var i = 0; i < array_length(self.children); i++) {
                var recursive_result = self.children[i].CheckObject(object);
                if (recursive_result != undefined) return recursive_result;
            }
        }
        
        return undefined;
    };
    
    static CheckRay = function(ray, hit_info, group = 1) {
        if (!ray.CheckAABB(self.bounds, new RaycastHitInformation())) return;
        
        var result = false;
        if (self.children == undefined) {
            for (var i = 0; i < array_length(self.contents); i++) {
                if (self.contents[i].CheckRay(ray, hit_info, group)) {
                    result = true;
                }
            }
        } else {
            for (var i = 0; i < array_length(self.children); i++) {
                if (self.children[i].CheckRay(ray, hit_info, group)) {
                    result = true;
                }
            }
        }
        
        return result;
    };
    
    static GetObjectsInFrustum = function(frustum, output) {
        var status = self.bounds.CheckFrustum(frustum);
        
        if (status == EFrustumResults.OUTSIDE)
            return;
        
        if (status == EFrustumResults.INSIDE || self.children == undefined) {
            var output_length = array_length(output);
            var contents_length = array_length(self.contents);
            array_resize(output, output_length + contents_length);
            array_copy(output, output_length, self.contents, 0, contents_length);
            return;
        }
        
        for (var i = 0, n = array_length(self.children); i < n; i++) {
            self.children[i].GetObjectsInFrustum(frustum, output);
        }
    };
}

function ColWorldQuadtree(bounds, depth) constructor {
    self.bounds = bounds;
    self.depth = depth;
    
    self.contents = [];
    self.children = undefined;
    
    static Split = function() {
        if (array_length(self.contents) == 0) return;
        if (self.children != undefined) return;
        
        var center = self.bounds.position;
        var sides = self.bounds.half_extents.Mul(new Vector3(0.5, 0.5, 1));
        
        self.children = [
            new ColWorldQuadtree(new ColAABB(center.Add(new Vector3(-sides.x,  sides.y, 0)), sides), self.depth - 1),
            new ColWorldQuadtree(new ColAABB(center.Add(new Vector3( sides.x,  sides.y, 0)), sides), self.depth - 1),
            new ColWorldQuadtree(new ColAABB(center.Add(new Vector3( sides.x, -sides.y, 0)), sides), self.depth - 1),
            new ColWorldQuadtree(new ColAABB(center.Add(new Vector3(-sides.x, -sides.y, 0)), sides), self.depth - 1),
        ];
        
        for (var i = 0; i < array_length(self.children); i++) {
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
        var index = array_get_index(self.contents, object);
        if (index != -1) {
            array_delete(self.contents, index, 1);
            for (var j = 0; j < array_length(self.children); j++) {
                self.children[j].Remove(object);
            }
        }
    };
    
    static CheckObject = function(object) {
        if (!object.shape.CheckAABB(self.bounds)) return;
        
        if (self.children == undefined) {
            for (var i = 0; i < array_length(self.contents); i++) {
                if (self.contents[i].CheckObject(object)) {
                    return self.contents[i];
                }
            }
        } else {
            for (var i = 0; i < array_length(self.children); i++) {
                var recursive_result = self.children[i].CheckObject(object);
                if (recursive_result != undefined) return recursive_result;
            }
        }
        
        return undefined;
    };
    
    static CheckRay = function(ray, hit_info, group = 1) {
        if (!ray.CheckAABB(self.bounds, new RaycastHitInformation())) return;
        
        var result = false;
        if (self.children == undefined) {
            for (var i = 0; i < array_length(self.contents); i++) {
                if (self.contents[i].CheckRay(ray, hit_info, group)) {
                    result = true;
                }
            }
        } else {
            for (var i = 0; i < array_length(self.children); i++) {
                if (self.children[i].CheckRay(ray, hit_info, group)) {
                    result = true;
                }
            }
        }
        
        return result;
    };
    
    static GetObjectsInFrustum = function(frustum, output) {
        var status = self.bounds.CheckFrustum(frustum);
        
        if (status == EFrustumResults.OUTSIDE)
            return;
        
        if (status == EFrustumResults.INSIDE || self.children == undefined) {
            var output_length = array_length(output);
            var contents_length = array_length(self.contents);
            array_resize(output, output_length + contents_length);
            array_copy(output, output_length, self.contents, 0, contents_length);
            return;
        }
        
        for (var i = 0, n = array_length(self.children); i < n; i++) {
            self.children[i].GetObjectsInFrustum(frustum, output);
        }
    };
}