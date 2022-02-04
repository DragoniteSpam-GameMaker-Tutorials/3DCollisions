function ColOctree(bounds, mesh) constructor {
    self.bounds = bounds;
    self.mesh = mesh;
    
    self.triangles = [];
    self.children = undefined;
    
    static DebugDraw = function() {
        self.bounds.DebugDraw();
        if (self.children != undefined) {
            for (var i = 0; i < 8; i++) {
                self.children[i].DebugDraw();
            }
        }
    };
    
    static Split = function(depth) {
        if (depth == 0) return;
        if (array_length(self.triangles) == 0) return;
        if (self.children != undefined) return;
        
        var center = self.bounds.position;
        var sides = self.bounds.half_extents.Mul(0.5);
        
        self.children = [
            new ColOctree(new ColAABB(center.Add(new Vector3(-sides.x,  sides.y, -sides.z)), sides), self.mesh),
            new ColOctree(new ColAABB(center.Add(new Vector3( sides.x,  sides.y, -sides.z)), sides), self.mesh),
            new ColOctree(new ColAABB(center.Add(new Vector3(-sides.x,  sides.y,  sides.z)), sides), self.mesh),
            new ColOctree(new ColAABB(center.Add(new Vector3( sides.x,  sides.y,  sides.z)), sides), self.mesh),
            new ColOctree(new ColAABB(center.Add(new Vector3(-sides.x, -sides.y, -sides.z)), sides), self.mesh),
            new ColOctree(new ColAABB(center.Add(new Vector3( sides.x, -sides.y, -sides.z)), sides), self.mesh),
            new ColOctree(new ColAABB(center.Add(new Vector3(-sides.x, -sides.y,  sides.z)), sides), self.mesh),
            new ColOctree(new ColAABB(center.Add(new Vector3( sides.x, -sides.y,  sides.z)), sides), self.mesh),
        ];
        
        for (var i = 0; i < 8; i++) {
            var tree = self.children[i];
            for (var j = 0; j < array_length(self.triangles); j++) {
                if (tree.bounds.CheckTriangle(self.triangles[j])) {
                    array_push(tree.triangles, self.triangles[j]);
                }
            }
            tree.Split(depth - 1);
        }
    };
}