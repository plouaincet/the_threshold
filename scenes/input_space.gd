extends HBoxContainer
@onready var text_edit1: LineEdit = $InputBox1/TextEdit1
@onready var text_edit2: LineEdit = $InputBox2/TextEdit2
@onready var texture_rect1: TextureRect = $InputBox1/TextureRect1
@onready var texture_rect2: TextureRect = $InputBox2/TextureRect2
signal WrittenTime(time1:int, time2:int)


func _ready() -> void:
	text_edit1.text_changed.connect(_on_text_changed.bind(text_edit1))
	text_edit2.text_changed.connect(_on_text_changed.bind(text_edit2))
	var empty_style := StyleBoxEmpty.new()
	text_edit1.add_theme_stylebox_override("focus", empty_style)
	text_edit2.add_theme_stylebox_override("focus", empty_style)

func _on_text_changed(new_text: String, line_edit: LineEdit) -> void:
	if new_text.length() >= 3:
		var trimmed = new_text.erase(0, 2)
		line_edit.text = trimmed
		call_deferred("_fix_caret", line_edit, trimmed.length())

func _fix_caret(line_edit: LineEdit, pos: int) -> void:
	line_edit.caret_column = pos

func _on_text_edit_1_focus_entered() -> void:
	texture_rect1.self_modulate=Color(184.0/255.0, 184.0/255.0, 184.0/255.0)

func _on_text_edit_1_focus_exited() -> void:
	var time1 = text_edit1.text
	var time2 = text_edit2.text
	texture_rect1.self_modulate=Color(1, 1, 1)
	if text_edit1.text==null:
		time1=0
	if text_edit2.text==null:
		time2=0
	emit_signal("WrittenTime", int(time1), int(time2))

func _on_text_edit_2_focus_entered() -> void:
	texture_rect2.self_modulate=Color(184.0/255.0, 184.0/255.0, 184.0/255.0)

func _on_text_edit_2_focus_exited() -> void:
	texture_rect2.self_modulate=Color(1, 1, 1)
	var time1 = text_edit1.text
	var time2 = text_edit2.text
	texture_rect1.self_modulate=Color(1, 1, 1)
	if text_edit1.text==null:
		time1=0
	if text_edit2.text==null:
		time2=0
	emit_signal("WrittenTime", int(time1), int(time2))
