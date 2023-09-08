function Vector3(x, y, z) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
	
	static Zero = function() { return new Vector3(0, 0, 0); };
	static One = function() { return new Vector3(1, 1, 1); };
	static Infinity = function() { return new Vector3(infinity, infinity, infinity); };
	static NegativeInfinity = function() { return new Vector3(-infinity, -infinity, -infinity); };
	
	static toString = function() {
		return string("({0}, {1}, {2})", self.x, self.y, self.z);
	};
	
	static Set = function(x, y, z) {
	    self.x = x;
	    self.y = y;
	    self.z = z;
	};
	
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
        var mag = point_distance_3d(0, 0, 0, self.x, self.y, self.z);
        return new Vector3(self.x / mag, self.y / mag, self.z / mag);
    };
    
	static Clamp = function(a, b) {
		if (is_struct(a)) {
			return new Vector3(clamp(self.x, a.x, b.x), clamp(self.y, a.y, b.y), clamp(self.z, a.z, b.z));
		}
		return new Vector3(clamp(self.x, a, b), clamp(self.y, a, b), clamp(self.z, a, b));
	};
    
    static ClampMagnitude = function(magnitude) {
        var d = point_distance_3d(0, 0, 0, self.x, self.y, self.z) / magnitude;
        return new Vector3(self.x / d, self.y / d, self.z / d);
    };
    
    static Abs = function() {
        return new Vector3(abs(self.x), abs(self.y), abs(self.z));
    };
    
    static Project = function(direction) {
        var f = dot_product_3d(self.x, self.y, self.z, direction.x, direction.y, direction.z) / dot_product_3d(direction.x, direction.y, direction.z, direction.x, direction.y, direction.z);
        return new Vector3(direction.x * f, direction.y * f, direction.z * f);
    };
    
    static Min = function(val) {
		if (is_numeric(val)) {
			return new Vector3(min(self.x, val), min(self.y, val), min(self.z, val));
		}
        return new Vector3(min(self.x, val.x), min(self.y, val.y), min(self.z, val.z));
    };
    
    static Max = function(val) {
		if (is_numeric(val)) {
			return new Vector3(max(self.x, val), max(self.y, val), max(self.z, val));
		}
        return new Vector3(max(self.x, val.x), max(self.y, val.y), max(self.z, val.z));
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
	
	static Approach = function(target, amount) {
		var dist = point_distance_3d(target.x, target.y, target.z, self.x, self.y, self.z);
		var f = min(amount, dist) / dist;
		return new Vector3(lerp(self.x, target.x, f), lerp(self.y, target.y, f), lerp(self.z, target.z, f));
	};
	
	static Lerp = function(target, amount) {
		return new Vector3(lerp(self.x, target.x, amount), lerp(self.y, target.y, amount), lerp(self.z, target.z, amount));
	};
	
	static Angle = function(vec3) {
		return darccos(dot_product_3d(self.x, self.y, self.z, vec3.x, vec3.y, vec3.z) / (point_distance_3d(0, 0, 0, self.x, self.y, self.z) * point_distance_3d(0, 0, 0, vec3.x, vec3.y, vec3.z)));
	};
}

function Vector4(x, y, z, w) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    self.w = w;
    
	static Zero = function() { return new Vector4(0, 0, 0, 0); };
	static One = function() { return new Vector4(1, 1, 1, 1); };
	static Infinity = function() { return new Vector4(infinity, infinity, infinity, infinity); };
	static NegativeInfinity = function() { return new Vector4(-infinity, -infinity, -infinity, -infinity); };
	
	static toString = function() {
		return string("({0}, {1}, {2}, {3})", self.x, self.y, self.z, self.w);
	};
	
	static Set = function(x, y, z, w) {
	    self.x = x;
	    self.y = y;
	    self.z = z;
	    self.w = w;
	};
	
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
        return sqrt(sqr(self.x) + sqr(self.y) + sqr(self.z) + sqr(self.w));
    };
    
    static DistanceTo = function(val) {
        return sqrt(sqr(self.x - val.x) + sqr(self.y - val.y) + sqrt(self.z - val.z) + sqr(self.w - val.w));
    };
    
    static Dot = function(val) {
        return dot_product_3d(self.x, self.y, self.z, val.x, val.y, val.z) + self.w * val.w;
    };
    
    static Equals = function(val) {
        return (self.x == val.x) && (self.y == val.y) && (self.z == val.z) && (self.w == val.w);
    };
    
    static Normalize = function() {
        var mag = sqrt(sqr(self.x) + sqr(self.y) + sqr(self.z) + sqr(self.w));
        return new Vector4(self.x / mag, self.y / mag, self.z / mag, self.w / mag);
    };
	
	static Clamp = function(a, b) {
		if (is_struct(a)) {
			return new Vector4(clamp(self.x, a.x, b.x), clamp(self.y, a.y, b.y), clamp(self.z, a.z, b.z), clamp(self.w, a.w, b.w));
		}
		return new Vector4(clamp(self.x, a, b), clamp(self.y, a, b), clamp(self.z, a, b), clamp(self.w, a, b));
	};
    
    static ClampMagnitude = function(magnitude) {
        var d = sqrt(sqr(self.x) + sqr(self.y) + sqr(self.z) + sqr(self.w)) / magnitude;
        return new Vector4(self.x / d, self.y / d, self.z / d, self.w / d);
    };
    
    static Abs = function() {
        return new Vector4(abs(self.x), abs(self.y), abs(self.z), abs(self.w));
    };
    
    static Project = function(direction) {
        var f = (dot_product_3d(self.x, self.y, self.z, direction.x, direction.y, direction.z) + self.w * direction.w) / (dot_product_3d(direction.x, direction.y, direction.z, direction.x, direction.y, direction.z) + direction.w * direction.w);
        return new Vector4(direction.x * f, direction.y * f, direction.z * f, direction.w * f);
    };
    
    static Min = function(val) {
		if (is_numeric(val)) {
			return new Vector4(min(self.x, val), min(self.y, val), min(self.z, val), min(self.w, val));
		}
        return new Vector4(min(self.x, val.x), min(self.y, val.y), min(self.z, val.z), min(self.w, val.w));
    };
    
    static Max = function(val) {
		if (is_numeric(val)) {
			return new Vector4(max(self.x, val), max(self.y, val), max(self.z, val), max(self.w, val));
		}
        return new Vector4(max(self.x, val.x), max(self.y, val.y), max(self.z, val.z), max(self.w, val.w));
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
	
	static Approach = function(target, amount) {
		var dist = sqrt(sqr(self.x - target.x) + sqr(self.y - target.y) + sqrt(self.z - target.z) + sqr(self.w - target.w));
		var f = min(amount, dist) / dist;
		return new Vector4(lerp(self.x, target.x, f), lerp(self.y, target.y, f), lerp(self.z, target.z, f), lerp(self.w, target.w, f));
	};
	
	static Lerp = function(target, amount) {
		return new Vector4(lerp(self.x, target.x, amount), lerp(self.y, target.y, amount), lerp(self.z, target.z, amount), lerp(self.w, target.w, amount));
	};
	
	static Angle = function(vec4) {
		return darccos((dot_product_3d(self.x, self.y, self.z, vec4.x, vec4.y, vec4.z) + self.w * vec4.w) / (sqrt(sqr(self.x) + sqr(self.y) + sqr(self.z) + sqr(self.w)) * sqrt(sqr(vec4.x) + sqr(vec4.y) + sqr(vec4.z) + sqr(vec4.w))));
	};
}
round
Vector3(0, 0, 0);
Vector4(0, 0, 0, 0);