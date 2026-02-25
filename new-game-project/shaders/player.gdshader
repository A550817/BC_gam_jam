shader_type canvas_item;

uniform float feather : hint_range(0.0, 0.3) = 0.02;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    float dist = distance(UV, vec2(0.5));
    float mask = 1.0 - smoothstep(0.5 - feather, 0.5, dist);

    color.a *= mask;
    COLOR = color;
}