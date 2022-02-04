function ColOctree(bounds, mesh) constructor {
    self.bounds = bounds;
    self.mesh = mesh;
    
    self.triangles = [];
    self.children = undefined;
}