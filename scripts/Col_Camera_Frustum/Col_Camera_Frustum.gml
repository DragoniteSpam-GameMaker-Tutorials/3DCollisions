/// these two matrices are going to be Matrix4 instances
function ColCameraFrustum(view_mat, proj_mat) constructor {
    var vp = view_mat.Mul(proj_mat);
    
    var c1 = new Vector3(vp.x.x, vp.x.y, vp.x.z);
    var c2 = new Vector3(vp.y.x, vp.y.y, vp.y.z);
    var c3 = new Vector3(vp.z.x, vp.z.y, vp.z.z);
    var c4 = new Vector3(vp.w.x, vp.w.y, vp.w.z);
    
    self.left =         new ColPlane(c4.Add(c1), vp.w.w + vp.x.w).Normalize();
    self.right =        new ColPlane(c4.Sub(c1), vp.w.w - vp.x.w).Normalize();
    self.bottom  =      new ColPlane(c4.Add(c2), vp.w.w + vp.y.w).Normalize();
    self.top =          new ColPlane(c4.Sub(c2), vp.w.w - vp.y.w).Normalize();
    self.near =         new ColPlane(c4.Add(c3), vp.w.w + vp.z.w).Normalize();
    self.far =          new ColPlane(c4.Sub(c3), vp.w.w - vp.z.w).Normalize();
    
    static AsArray = function() {
        return [self.left, self.right, self.bottom, self.top, self.near, self.far];
    };
    
    static GetCorners = function() {
        return [
            col_three_plane_intersection(self.near,   self.top,       self.left),
            col_three_plane_intersection(self.near,   self.top,       self.right),
            col_three_plane_intersection(self.near,   self.bottom,    self.left),
            col_three_plane_intersection(self.near,   self.bottom,    self.right),
            col_three_plane_intersection(self.far,    self.top,       self.left),
            col_three_plane_intersection(self.far,    self.top,       self.right),
            col_three_plane_intersection(self.far,    self.bottom,    self.left),
            col_three_plane_intersection(self.far,    self.bottom,    self.right)
        ];
    };
    
    static DebugDraw = function() {
        var corners = self.GetCorners();
        
        matrix_set(matrix_world, matrix_build_identity());
        
        static vertex_add_point = function(vbuff, point, colour) {
            vertex_position_3d(vbuff, point.x, point.y, point.z);
            vertex_normal(vbuff, 0, 0, 1);
            vertex_texcoord(vbuff, 0, 0);
            vertex_colour(vbuff, colour, 1);
        };
        
        static vb_lines = vertex_create_buffer();
        vertex_begin(vb_lines, obj_camera.format);
        
        // near
        vertex_add_point(vb_lines, corners[0], c_yellow);
        vertex_add_point(vb_lines, corners[1], c_yellow);
        
        vertex_add_point(vb_lines, corners[2], c_yellow);
        vertex_add_point(vb_lines, corners[3], c_yellow);
        
        vertex_add_point(vb_lines, corners[0], c_yellow);
        vertex_add_point(vb_lines, corners[2], c_yellow);
        
        vertex_add_point(vb_lines, corners[1], c_yellow);
        vertex_add_point(vb_lines, corners[3], c_yellow);
        
        // far
        vertex_add_point(vb_lines, corners[4], c_yellow);
        vertex_add_point(vb_lines, corners[5], c_yellow);
        
        vertex_add_point(vb_lines, corners[6], c_yellow);
        vertex_add_point(vb_lines, corners[7], c_yellow);
        
        vertex_add_point(vb_lines, corners[4], c_yellow);
        vertex_add_point(vb_lines, corners[6], c_yellow);
        
        vertex_add_point(vb_lines, corners[5], c_yellow);
        vertex_add_point(vb_lines, corners[7], c_yellow);
        
        // sides
        vertex_add_point(vb_lines, corners[0], c_yellow);
        vertex_add_point(vb_lines, corners[4], c_yellow);
        
        vertex_add_point(vb_lines, corners[1], c_yellow);
        vertex_add_point(vb_lines, corners[5], c_yellow);
        
        vertex_add_point(vb_lines, corners[2], c_yellow);
        vertex_add_point(vb_lines, corners[6], c_yellow);
        
        vertex_add_point(vb_lines, corners[3], c_yellow);
        vertex_add_point(vb_lines, corners[7], c_yellow);
        
        vertex_end(vb_lines);
        
        vertex_submit(vb_lines, pr_linelist, -1);
    };
}

function col_three_plane_intersection(p1, p2, p3) {
    var p2xp3 = p2.normal.Cross(p3.normal);
    var p3xp1 = p3.normal.Cross(p1.normal);
    var p1xp2 = p1.normal.Cross(p2.normal);
    
    var cross_product_sum = p2xp3.Mul(-p1.distance)
        .Add(p3xp1.Mul(-p2.distance))
        .Add(p1xp2.Mul(-p3.distance));
    
    return cross_product_sum.Div(p1.normal.Dot(p2xp3));
}

enum EFrustumResults {
    OUTSIDE,
    INTERSECTING,
    INSIDE
}