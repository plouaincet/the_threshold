extends Graffiti
var fade_tween: Tween
@onready var point_light: PointLight2D = $PointLight2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var game: Node2D = $"../.."
@onready var Wipe: AudioStreamPlayer2D = $"../Wipe"
var bites: Array[Vector3] = []
var max_bites := 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_light.visible=false
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("bite_count", 0)
	sprite.material.set_shader_parameter("bites", bites)


func wipe(_player: Node) -> void:
	Wipe.play()
	game.add_graffities(name,0.2)
	if bites.size() >= max_bites:
		return

	# Random position, slightly outside the sprite too
	var pos := Vector2(
		randf_range(0.05, 1.1),
		randf_range(0.05, 1.1)
	)
	var progress := float(bites.size()) / float(max_bites)

	var radius :float= lerp(
		0.30,
		0.50,
		progress
	)

	radius += randf_range(-0.05, 0.05)

	# Final bite completely eats the remaining sprite
	if bites.size() == max_bites - 1:
		radius = 2.0

	# Store the bite
	bites.append(
		Vector3(
			pos.x,
			pos.y,
			radius
		)
	)

	# Update shader
	sprite.material.set_shader_parameter(
		"bite_count",
		bites.size()
	)

	sprite.material.set_shader_parameter(
		"bites",
		bites
	)

	# After the final bite, remove the graffiti
	if bites.size() >= max_bites:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func fade_out_graffiti() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(queue_free)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		point_light.visible=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		point_light.visible=false
