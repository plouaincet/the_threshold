extends Node
@onready var scene_manager: Node = $".."
@onready var pause_screen: CanvasLayer = $"../PauseScreen"
@onready var bg: TextureRect = $"../PauseScreen/TextureRect"
@onready var container: CenterContainer = $"../PauseScreen/CenterContainer"
var was_hidden:bool=false
func _unhandled_input(event):
	if event.is_action_pressed("pause") and scene_manager.get_child(0).name!="StartingScreen":
		get_tree().paused = !get_tree().paused
		pause_screen.visible=!pause_screen.visible
		if pause_screen.visible and Input.mouse_mode==Input.MOUSE_MODE_HIDDEN:
			was_hidden=true
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		elif !pause_screen.visible and was_hidden:
			Input.mouse_mode=Input.MOUSE_MODE_HIDDEN
func pause() ->void:
	get_tree().paused = false
	pause_screen.visible=false
	if pause_screen.visible and Input.mouse_mode==Input.MOUSE_MODE_HIDDEN:
			was_hidden=true
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	elif !pause_screen.visible and was_hidden:
		Input.mouse_mode=Input.MOUSE_MODE_HIDDEN
