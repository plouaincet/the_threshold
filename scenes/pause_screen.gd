extends CanvasLayer
@onready var resume: TextureButton = $CenterContainer/VBoxContainer/CenterContainer/TextureRect
@onready var instructions: TextureButton = $CenterContainer/VBoxContainer/CenterContainer2/instructions
@onready var hints: TextureButton = $CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/hints
@onready var return_to_title: TextureButton = $CenterContainer/VBoxContainer/CenterContainer4/return_to_title
@onready var for_pause_screen: Node = $"../ForPauseScreen"
@onready var scene_manager:Node = $".."
@onready var label: Label = $CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_texture_rect_mouse_entered() -> void:
	resume.modulate.a=0.5

func _on_texture_rect_mouse_exited() -> void:
	resume.modulate.a=1


func _on_instructions_mouse_entered() -> void:
	instructions.modulate.a=0.5

func _on_instructions_mouse_exited() -> void:
	instructions.modulate.a=1
	
func _on_hints_mouse_entered() -> void:
	hints.modulate.a=0.5

func _on_hints_mouse_exited() -> void:
	hints.modulate.a=1


func _on_return_to_title_mouse_entered() -> void:
	return_to_title.modulate.a=0.5


func _on_return_to_title_mouse_exited() -> void:
	return_to_title.modulate.a=1

func _on_texture_rect_pressed() -> void:
	for_pause_screen.pause()


func _on_instructions_pressed() -> void:
	var instructions_scene = preload("res://scenes/instructions.tscn").instantiate()
	add_child(instructions_scene)


func _on_hints_pressed() -> void:
	if scene_manager.hints_available>0:
		label.text=str(scene_manager.hints_available) + "/3"
		scene_manager.hints_available-=1
		var hints_scene = preload("res://scenes/hints.tscn").instantiate()
		label.text=str(scene_manager.hints_available) + "/3"
		add_child(hints_scene)


func _on_return_to_title_pressed() -> void:
	for_pause_screen.pause()
	visible=false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_parent().return_to_title()
