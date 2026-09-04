extends Control
@onready var scene_manager: Node = $"../../.."
@onready var label: Label = $CenterContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var seconds=scene_manager.leaderboard_time
	if seconds%60>9:
		@warning_ignore("integer_division")
		label.text=str(seconds/60) + ":" + str(seconds%60)
	else:
		@warning_ignore("integer_division")
		label.text=str(seconds/60) + ":0" + str(seconds%60)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
