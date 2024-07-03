// Taken from https://www.youtube.com/watch?v=ctevHwoRl24
shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0); // Put it on the editor, kind of like @export var
uniform float flash_modifier: hint_range(0.0, 1.0) = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
