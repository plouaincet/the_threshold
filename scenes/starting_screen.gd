extends Node

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var startcontrol1: TextureRect = $ButtonsSpace/VBoxContainer/StartGameContainer/HBoxContainer/Control
@onready var startcontrol2: TextureRect = $ButtonsSpace/VBoxContainer/StartGameContainer/HBoxContainer/Control2
@onready var instructcontrol1: TextureRect = $ButtonsSpace/VBoxContainer/InstructionsContainer/HBoxContainer/Control
@onready var instructcontrol2: TextureRect = $ButtonsSpace/VBoxContainer/InstructionsContainer/HBoxContainer/Control2
@onready var quitcontrol1: TextureRect = $ButtonsSpace/VBoxContainer/QuitContainer/HBoxContainer/Control
@onready var quitcontrol2: TextureRect = $ButtonsSpace/VBoxContainer/QuitContainer/HBoxContainer/Control2



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


func _on_start_game_mouse_entered() -> void:
	startcontrol1.modulate.a=100
	startcontrol2.modulate.a=100
	
func _on_instructions_mouse_entered() -> void:
	instructcontrol1.modulate.a=100
	instructcontrol2.modulate.a=100

func _on_quit_mouse_entered() -> void:
	quitcontrol1.modulate.a=100
	quitcontrol2.modulate.a=100

func _on_start_game_mouse_exited() -> void:
	startcontrol1.modulate.a=0
	startcontrol2.modulate.a=0

func _on_instructions_mouse_exited() -> void:
	instructcontrol1.modulate.a=0
	instructcontrol2.modulate.a=0

func _on_quit_mouse_exited() -> void:
	quitcontrol1.modulate.a=0
	quitcontrol2.modulate.a=0
