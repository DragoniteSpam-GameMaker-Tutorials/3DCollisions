function Vector3(x, y, z) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    
    static AsLinearArray = function() {
        return [self.x, self.y, self.z];
    };
    
    static Add = function(val) {
        if (is_numeric(val)) {
            return new Vector3(self.x + val, self.y + val, self.z + val);
        }
        return new Vector3(self.x + val.x, self.y + val.y, self.z + val.z);
    };
    
    static Sub = function(val) {
        if (is_numeric(val)) {
            return new Vector3(self.x - val, self.y - val, self.z - val);
        }
        return new Vector3(self.x - val.x, self.y - val.y, self.z - val.z);
    };
    
    static Mul = function(val) {
        if (is_numeric(val)) {
            return new Vector3(self.x * val, self.y * val, self.z * val);
        }
        return new Vector3(self.x * val.x, self.y * val.y, self.z * val.z);
    };
    
    static Div = function(val) {
        if (is_numeric(val)) {
            return new Vector3(self.x / val, self.y / val, self.z / val);
        }
        return new Vector3(self.x / val.x, self.y / val.y, self.z / val.z);
    };
    
    static Magnitude = function() {
        return point_distance_3d(0, 0, 0, self.x, self.y, self.z);
    };
    
    static DistanceTo = function(val) {
        return point_distance_3d(val.x, val.y, val.z, self.x, self.y, self.z);
    };
    
    static Dot = function(val) {
        return dot_product_3d(self.x, self.y, self.z, val.x, val.y, val.z);
    };
    
    static Cross = function(val) {
        return new Vector3(self.y * val.z - val.y * self.z, self.z * val.x - val.z * self.x, self.x * val.y - val.x * self.y);
    };
    
    static Equals = function(val) {
        return (self.x == val.x) && (self.y == val.y) && (self.z == val.z);
    };
    
    static Normalize = function() {
        var mag = self.Magnitude();
        return new Vector3(self.x / mag, self.y / mag, self.z / mag);
    };
    
    static Abs = function() {
        return new Vector3(abs(self.x), abs(self.y), abs(self.z));
    };
    
    static Project = function(direction) {
        var dot = self.Dot(direction);
        var mag = direction.Magnitude();
        return direction.Mul(dot / (mag * mag));
    };
    
    static Min = function(vec3) {
        return new Vector3(min(self.x, vec3.x), min(self.y, vec3.y), min(self.z, vec3.z));
    };
    
    static Max = function(vec3) {
        return new Vector3(max(self.x, vec3.x), max(self.y, vec3.y), max(self.z, vec3.z));
    };
    
    static Floor = function() {
        return new Vector3(floor(self.x), floor(self.y), floor(self.z));
    };
    
    static Ceil = function() {
        return new Vector3(ceil(self.x), ceil(self.y), ceil(self.z));
    };
    
    static Round = function() {
        return new Vector3(round(self.x), round(self.y), round(self.z));
    };
    
    static GetTranslationMatrix = function() {
        return new Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            self.x, self.y, self.z, 1
        );
    };
}

function Vector4(x, y, z, w) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    self.w = w;
    
    static AsLinearArray = function() {
        return [self.x, self.y, self.z, self.w];
    };
    
    static Add = function(val) {
        if (is_numeric(val)) {
            return new Vector4(self.x + val, self.y + val, self.z + val, self.w + val);
        }
        return new Vector4(self.x + val.x, self.y + val.y, self.z + val.z, self.w + val.w);
    };
    
    static Sub = function(val) {
        if (is_numeric(val)) {
            return new Vector4(self.x - val, self.y - val, self.z - val, self.w - val);
        }
        return new Vector4(self.x - val.x, self.y - val.y, self.z - val.z, self.w - val.w);
    };
    
    static Mul = function(val) {
        if (is_numeric(val)) {
            return new Vector4(self.x * val, self.y * val, self.z * val, self.w * val);
        }
        return new Vector4(self.x * val.x, self.y * val.y, self.z * val.z, self.w * val.w);
    };
    
    static Div = function(val) {
        if (is_numeric(val)) {
            return new Vector4(self.x / val, self.y / val, self.z / val, self.w / val);
        }
        return new Vector4(self.x / val.x, self.y / val.y, self.z / val.z, self.w / val.w);
    };
    
    static Magnitude = function() {
        return sqrt(self.Dot(self));
    };
    
    static DistanceTo = function(val) {
        return sqrt(sqrt(self.x - val.x) + sqr(self.y - val.y) + sqrt(self.z - val.z) + sqr(self.w - val.w));
    };
    
    static Dot = function(val) {
        return self.x * val.x + self.y * val.y + self.z * val.z + self.w * val.w;
    };
    
    static Equals = function(val) {
        return (self.x == val.x) && (self.y == val.y) && (self.z == val.z) && (self.w == val.w);
    };
    
    static Normalize = function() {
        var mag = self.Magnitude();
        return new Vector4(self.x / mag, self.y / mag, self.z / mag, self.w / mag);
    };
    
    static Abs = function() {
        return new Vector4(abs(self.x), abs(self.y), abs(self.z), abs(self.w));
    };
    
    static Project = function(direction) {
        var dot = self.Dot(direction);
        var mag = direction.Magnitude();
        return direction.Mul(dot / (mag * mag));
    };
    
    static Min = function(vec4) {
        return new Vector4(min(self.x, vec4.x), min(self.y, vec4.y), min(self.z, vec4.z), min(self.w, vec4.w));
    };
    
    static Max = function(vec4) {
        return new Vector4(max(self.x, vec4.x), max(self.y, vec4.y), max(self.z, vec4.z), max(self.w, vec4.w));
    };
    
    static Floor = function() {
        return new Vector4(floor(self.x), floor(self.y), floor(self.z), floor(self.w));
    };
    
    static Ceil = function() {
        return new Vector4(ceil(self.x), ceil(self.y), ceil(self.z), ceil(self.w));
    };
    
    static Round = function() {
        return new Vector4(round(self.x), round(self.y), round(self.z), round(self.w));
    };
    
    static GetTranslationMatrix = function() {
        return new Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            self.x, self.y, self.z, 1
        );
    };
}