extends Node2D
@onready var mirror: StaticBody2D = $"../Objects/Mirror"
var end_parallax:Vector2=Vector2.ZERO
@onready var game: Node2D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	mirror.parallax=end_parallax


func _on_parallax_area_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		end_parallax+=Vector2(-2,0)


func _on_parallax_area_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		end_parallax+=Vector2(2,0)

func _on_parallax_area_right_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		end_parallax+=Vector2(2,0)

func _on_parallax_area_left_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		end_parallax+=Vector2(-2,0)

func _on_parallax_area_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		end_parallax+=Vector2(0,2)

func _on_parallax_area_up_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		end_parallax+=Vector2(0,-2)

func _on_parallax_area_down_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		end_parallax+=Vector2(0,-2)

func _on_parallax_area_down_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		end_parallax+=Vector2(0,2)


func _on_area_2d_area_exited(area: Area2D) -> void:
	game.turn_light_back()
