function ColMesh(triangle_array) constructor {
    self.triangles = triangle_array;
    
    self.property_min = new Vector3(infinity, infinity, infinity);
    self.property_max = new Vector3(-infinity, -infinity, -infinity);
    
    var bmn = self.property_min;
    var bmx = self.property_max;
    
    var i = 0;
    repeat (array_length(triangle_array)) {
        var tri = triangle_array[i++];
        bmn.x = min(bmn.x, tri.a.x, tri.b.x, tri.c.x);
        bmn.y = min(bmn.y, tri.a.y, tri.b.y, tri.c.y);
        bmn.z = min(bmn.z, tri.a.z, tri.b.z, tri.c.z);
        bmx.x = max(bmx.x, tri.a.x, tri.b.x, tri.c.x);
        bmx.y = max(bmx.y, tri.a.y, tri.b.y, tri.c.y);
        bmx.z = max(bmx.z, tri.a.z, tri.b.z, tri.c.z);
    }
    
    self.bounds = NewColAABBFromMinMax(bmn, bmx);
    
    self.accelerator = new self.octree(self.bounds, self.octree);
    self.accelerator.triangles = triangle_array;
    self.accelerator.Split(3);
    
    static octree = function(bounds, octree) constructor {
        self.bounds = bounds;
        self.octree = octree;
        
        self.triangles = [];
        self.children = undefined;
        
        static Split = function(depth) {
            if (depth == 0) return;
            if (array_length(self.triangles) == 0) return;
            if (self.children != undefined) return;
            
            var center = self.bounds.position;
            var sides = self.bounds.half_extents.Mul(0.5);
            var sx = sides.x, sy = sides.y, sz = sides.z;
            var tree = self.octree;
            
            self.children = [
                new self.octree(new ColAABB(center.Add(new Vector3(-sx,  sy, -sz)), sides), tree),
                new self.octree(new ColAABB(center.Add(new Vector3( sx,  sy, -sz)), sides), tree),
                new self.octree(new ColAABB(center.Add(new Vector3(-sx,  sy,  sz)), sides), tree),
                new self.octree(new ColAABB(center.Add(new Vector3( sx,  sy,  sz)), sides), tree),
                new self.octree(new ColAABB(center.Add(new Vector3(-sx, -sy, -sz)), sides), tree),
                new self.octree(new ColAABB(center.Add(new Vector3( sx, -sy, -sz)), sides), tree),
                new self.octree(new ColAABB(center.Add(new Vector3(-sx, -sy,  sz)), sides), tree),
                new self.octree(new ColAABB(center.Add(new Vector3( sx, -sy,  sz)), sides), tree),
            ];
            
            array_foreach(self.children, method({ triangles: self.triangles, d: depth - 1 }, function(node) {
                array_foreach(self.triangles, method({ node: node }, function(triangle) {
                    if (self.node.bounds.CheckTriangle(triangle)) {
                        array_push(self.node.triangles, triangle);
                    }
                }));
                node.Split(self.d);
            }));
        };
    };
    
    static CheckObject = function(object) {
        return object.shape.CheckMesh(self);
    };
    
    static CheckGeneral = function(shape) {
        var process_these = [self.accelerator];
        
        while (array_length(process_these) > 0) {
            var tree = process_these[0];
            array_delete(process_these, 0, 1);
            
            if (tree.children == undefined) {
                var i = 0;
                repeat (array_length(tree.triangles)) {
                    if (shape.CheckTriangle(tree.triangles[i++])) {
                        return true;
                    }
                }
            } else {
                for (var i = 0; i < 8; i++) {
                    if (shape.CheckAABB(tree.children[i].bounds)) {
                        array_push(process_these, tree.children[i]);
                    }
                }
            }
        }
        
        return false;
    };
    
    static CheckPoint = function(point) {
        return self.CheckGeneral(point);
    };
    
    static CheckSphere = function(sphere) {
        return self.CheckGeneral(sphere);
    };
    
    static CheckAABB = function(aabb) {
        return self.CheckGeneral(aabb);
    };
    
    static CheckPlane = function(plane) {
        return self.CheckGeneral(plane);
    };
    
    static CheckTriangle = function(triangle) {
        return self.CheckGeneral(triangle);
    };
    
    static CheckMesh = function(mesh) {
        return self.CheckGeneral(mesh);
    };
    
    static CheckModel = function(model) {
        return false;
    };
    
    static CheckOBB = function(obb) {
        return self.CheckGeneral(obb);
    };
    
    static CheckCapsule = function(capsule) {
        return self.CheckGeneral(capsule);
    };
    
    static CheckRay = function(ray, hit_info) {
        var process_these = [self.accelerator];
        static dummy_hit_info = new RaycastHitInformation();
        dummy_hit_info.distance = infinity;
        
        var hit_detected = false;
        
        while (array_length(process_these) > 0) {
            var tree = process_these[0];
            array_delete(process_these, 0, 1);
            
            if (tree.children == undefined) {
                for (var i = 0, n = array_length(tree.triangles); i < n; i++) {
                    if (ray.CheckTriangle(tree.triangles[i], hit_info)) {
                        hit_detected = true;
                    }
                }
            } else {
                for (var i = 0; i < 8; i++) {
                    if (ray.CheckAABB(tree.children[i].bounds, dummy_hit_info)) {
                        array_push(process_these, tree.children[i]);
                    }
                }
            }
        }
        
        return hit_detected;
    };
    
    static CheckLine = function(line) {
        static hit_info = new RaycastHitInformation();
        hit_info.distance = infinity;
        
        if (self.CheckRay(line.property_ray, hit_info)) {
            return (hit_info.distance <= line.property_length);
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