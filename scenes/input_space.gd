extends HBoxContainer
@onready var text_edit1: LineEdit = $InputBox1/TextEdit1
@onready var text_edit2: LineEdit = $InputBox2/TextEdit2
@onready var texture_rect1: TextureRect = $InputBox1/TextureRect1
@onready var texture_rect2: TextureRect = $InputBox2/TextureRect2
@onready var clock_minigame: CanvasLayer = $"../../../../../.."
@onready var clock: StaticBody2D= $"../../../../../../../Objects/Clock"
#signal WrittenTime(time1:int, time2:int)

func _ready() -> void:
	clock.ClockMinigameInteracted.connect(_handle_minigame_visibility)
	var empty_style := StyleBoxEmpty.new()
	text_edit1.add_theme_stylebox_override("focus", empty_style)
	text_edit2.add_theme_stylebox_override("focus", empty_style)

func _on_text_edit_1_focus_entered() -> void:
	texture_rect1.self_modulate=Color(140.0/255.0, 140.0/255.0, 140.0/255.0)

func _on_text_edit_1_focus_exited() -> void:
	var time1 = text_edit1.text
	var time2 = text_edit2.text
	texture_rect1.self_modulate=Color(1, 1, 1)
	if text_edit1.text==null:
		time1=0
	if text_edit2.text==null:
		time2=0
	#emit_signal("WrittenTime", int(time1), int(time2))

func _on_text_edit_2_focus_entered() -> void:
	texture_rect2.self_modulate=Color(140.0/255.0, 140.0/255.0, 140.0/255.0)

func _on_text_edit_2_focus_exited() -> void:
	texture_rect2.self_modulate=Color(1, 1, 1)
	var time1 = text_edit1.text
	var time2 = text_edit2.text
	if text_edit1.text==null:
		time1=0
	if text_edit2.text==null:
		time2=0
	#emit_signal("WrittenTime", int(time1), int(time2))

func _handle_minigame_visibility() -> void:
	text_edit1.grab_focus()


func _on_text_edit_1_text_changed(new_text: String) -> void:
	if new_text[-1] == "e" or new_text[-1] == "E":
		clock_minigame.visible=false
		text_edit1.text=""
	if new_text.length()==2:
		text_edit1.release_focus()
		text_edit2.grab_focus()

func _on_text_edit_2_text_changed(new_text: String) -> void:
	if new_text[-1] == "e" or new_text[-1] == "E":
		clock_minigame.visibale=false
		text_edit2.text=""
	if new_text.length()==2:
		text_edit2.release_focus()
