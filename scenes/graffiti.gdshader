shader_type canvas_item;

const int MAX_BITES = 5;

uniform int bite_count = 0;
uniform vec3 bites[MAX_BITES];


void fragment() {
	vec4 color = texture(TEXTURE, UV);

	for (int i = 0; i < MAX_BITES; i++) 
	{
		if (i >= bite_count) 
		{
			break;
		}

		vec2 bite_position = bites[i].xy;
		float bite_radius = bites[i].z;

		float distance_to_bite = distance(UV, bite_position);

		// Remove pixels inside the bite
		float wobble = sin(UV.x * 80.0 + float(i) * 5.0) + cos(UV.y * 70.0 + float(i) * 3.0);

		float noisy_radius = bite_radius + wobble * 0.01;

		if (distance_to_bite < noisy_radius) 
		{
			discard;
		}
	}

	COLOR = color;
}