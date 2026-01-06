shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D fog_texture : hint_default_black;
uniform float fog_speed = 3.0;

void fragment() {
  float phi = TIME*0.01;
  vec2 direction = vec2(sin(phi), cos(phi));
  vec2 noise_uv = mod(UV + (direction * phi * fog_speed), 1.0);
  COLOR = vec4(1.0);
  COLOR.a = texture(fog_texture, noise_uv).x;
}
