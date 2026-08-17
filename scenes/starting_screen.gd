extends Node

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

#@onready var scene_manager: Node = $".."
signal game_entered()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.play()
	'''arrow_1.position=Vector2(364,163)
	arrow_2.position=Vector2(555,162)'''

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_game_pressed() -> void:
	emit_signal("game_entered")


func _on_quit_pressed() -> void:
	get_tree().quit()
