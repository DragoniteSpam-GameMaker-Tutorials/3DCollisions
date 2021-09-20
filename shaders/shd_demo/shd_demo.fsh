varying vec4 v_vColour;
varying vec3 v_vWorldNormal;

//uniform vec3 lightDirection;
//uniform vec3 lightColor;

void main() {
    vec3 lightDirection = vec3(-1, -0.9, -0.8);
    vec3 lightColor = vec3(1, 1, 1);
    vec4 color = vec4(lightColor, 1);
    gl_FragColor = v_vColour * max(0.25, -dot(normalize(v_vWorldNormal), normalize(lightDirection))) * color;
    gl_FragColor.a = 1.;
}