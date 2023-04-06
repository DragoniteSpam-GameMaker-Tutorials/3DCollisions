function ColHeightmap(buffer, w, h) constructor {
    self.buffer = buffer;
    self.w = w;
    self.h = h;
    
    static GetHeight = function(x, y) {
        x = clamp(x, 0, self.w - 1);
        y = clamp(y, 0, self.h - 1);
        
        x = floor(x);
        y = floor(y);
        
        var index = x * self.h + y;
        var data_type_size = buffer_sizeof(buffer_f32);
        
        var z_at_this_position = buffer_peek(self.buffer, index * data_type_size, buffer_f32);
        
        return z_at_this_position;
    };
}