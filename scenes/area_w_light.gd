extends Area2D
@onready var player: CharacterBody2D = $"../../player"
@onready var game: Node = $"../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func check_for_player() -> bool:
	var bodies := get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player") and game.light_state:
			return true
	return false
