function ColWorldSpatialHash(chunk_size) constructor {
    self.chunk_size = chunk_size;
    self.chunks = { };
    
    self.bounds = undefined;
    self.object_record = { };
    
    self.planes = [];
    
    static DebugDraw = function() {
        self.bounds.DebugDraw();
        struct_foreach(self.chunks, function(chunk) {
            self.chunks[$ chunk].DebugDraw();
        });
    };
    
    static HashFunction = function(x, y, z) {
        return $"{x}{y}{z}";
    };
    
    static GetBoundingChunk = function(object) {
        var object_min = object.GetMin();
        var object_max = object.GetMax();
        
        if (object_min == undefined) {
            return undefined;
        }
        
        return NewColAABBFromMinMax(
            new Vector3(floor(object_min.x / self.chunk_size), floor(object_min.y / self.chunk_size), floor(object_min.z / self.chunk_size)),
            new Vector3(floor(object_max.x / self.chunk_size), floor(object_max.y / self.chunk_size), floor(object_max.z / self.chunk_size))
        );
    };
    
    static GetChunk = function(x, y, z) {
        return self.chunks[$ self.HashFunction(x, y, z)];
    };
    
    static AddChunk = function(x, y, z, chunk) {
        self.chunks[$ self.HashFunction(x, y, z)] = chunk;
    };
    
    static RemoveChunk = function(x, y, z) {
        variable_struct_remove(self.chunks, self.HashFunction(x, y, z));
    };
    
    static Contains = function(object) {
        return self.object_record[$ string(ptr(object))];
    };
    
    static Add = function(object) {
        var bounds = self.GetBoundingChunk(object);
        
        if (bounds == undefined) {
            if (array_get_index(self.planes, object) == -1) {
                array_push(self.planes, object);
            }
            return;
        }
        
        var bounds_min = bounds.GetMin();
        var bounds_max = bounds.GetMax();
        
        // is the object already in the spatial hash?
        var location = self.Contains(object);
        if (location != undefined) {
            if (location.GetMin().Equals(bounds_min) && location.GetMax().Equals(bounds_max)) {
                // object's position is the same, there's no point
                return;
            } else {
                self.Remove(object);
            }
        }
        
        for (var i = bounds_min.x; i <= bounds_max.x; i++) {
            for (var j = bounds_min.y; j <= bounds_max.y; j++) {
                for (var k = bounds_min.z; k <= bounds_max.z; k++) {
                    var chunk = self.GetChunk(i, j, k);
                    
                    if (chunk == undefined) {
                        var coords = new Vector3(i, j, k);
                        var coords_min = coords.Mul(self.chunk_size);
                        var coords_max = coords.Mul(self.chunk_size).Add(self.chunk_size);
                        
                        var chunk_bounds = NewColAABBFromMinMax(coords_min, coords_max);
                        chunk = new ColSpatialHashNode(chunk_bounds);
                        self.AddChunk(i, j, k, chunk);
                        
                        if (self.bounds == undefined) {
                            self.bounds = NewColAABBFromMinMax(coords_min, coords_max);
                        } else {
                            self.bounds = NewColAABBFromMinMax(
                                self.bounds.GetMin().Min(coords_min),
                                self.bounds.GetMax().Max(coords_max)
                            );
                        }
                    }
                    
                    chunk.Add(object);
                    
                    var object_id = string(ptr(object));
                    self.object_record[$ object_id] = bounds;
                }
            }
        }
    };
    
    static Remove = function(object) {
        var plane_index = array_get_index(self.planes, object);
        if (plane_index != -1) {
            array_delete(self.planes, plane_index, 1);
            return;
        }
        
        var location = self.Contains(object);
        if (location == undefined) {
            return;
        }
        
        var bounds_min = location.GetMin();
        var bounds_max = location.GetMax();
        
        for (var i = bounds_min.x; i <= bounds_max.x; i++) {
            for (var j = bounds_min.y; j <= bounds_max.y; j++) {
                for (var k = bounds_min.z; k <= bounds_max.z; k++) {
                    var chunk = self.GetChunk(i, j, k);
                    chunk.Remove(object);
                    
                    if (chunk.Size() == 0) {
                        self.RemoveChunk(i, j, k);
                        
                        // you may want to resize the bounds of the spatial hash
                        // after removing an empty chunk, but i dont know if a nice
                        // way to do that besides looping over every chunk from
                        // scratch so I won't be doing that here
                    }
                }
            }
        }
        
        var object_id = string(ptr(object));
        variable_struct_remove(self.object_record, object_id);
    };
    
    static CheckObject = function(object) {
        
    };
    
    static CheckRay = function(ray, group = 1) {
        
    };
}

function ColSpatialHashNode(bounds) constructor {
    self.bounds = bounds;
    self.objects = [];
    
    static DebugDraw = function() {
        self.bounds.DebugDraw();
        array_foreach(self.objects, function(object) {
            if (object.shape[$ "DebugDraw"])
                object.shape.DebugDraw();
        });
    };
    
    static Add = function(object) {
        array_push(self.objects, object);
    };
    
    static Remove = function(object) {
        var index = array_get_index(self.objects, object);
        array_delete(self.objects, index, 1);
    };
    
    static Size = function() {
        return array_length(self.objects);
    };
    
    static CheckObject = function(object) {
        for (var i = 0; i < array_length(self.objects); i++) {
            if (self.objects[i].CheckObject(object))
                return true;
        }
        return false;
    };
    
    static CheckRay = function(ray, hit_info, group = 1) {
        var hit_detected = false;
        for (var i = 0; i < array_length(self.objects); i++) {
            if (self.objects[i].CheckRay(ray, hit_info, group))
                hit_detected = true;
        }
        return hit_detected;
    };
}