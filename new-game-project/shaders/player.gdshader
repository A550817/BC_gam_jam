shader_type canvas_item;

uniform float radius : hint_range(0.0, 0.5) = 0.5;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    // UV center of sprite
    vec2 center = vec2(0.5);

    float dist = distance(UV, center);

    float mask;

    mask = step(dist, radius);

    color.a *= mask;

    COLOR = color;
}