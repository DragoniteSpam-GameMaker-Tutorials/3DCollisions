function ColWorldSpatialHash(chunk_size) constructor {
    self.chunk_size = chunk_size;
    self.chunks = { };
    
    self.bounds = undefined;
    self.object_record = { };
    
    self.planes = [];
    
    static DebugDraw = function() {
        
    };
    
    static HashFunction = function(x, y, z) {
        
    };
    
    static GetBoundingChunk = function(object) {
        
    };
    
    static GetChunk = function(x, y, z) {
        
    };
    
    static Add = function(object) {
        
    };
    
    static Remove = function(object) {
        
    };
    
    static CheckObject = function(object, group = 1) {
        
    };
    
    static CheckRay = function(ray, group = 1) {
        
    };
}