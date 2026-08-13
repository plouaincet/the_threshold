extends HBoxContainer

@onready var text_edit1: LineEdit = $InputBox1/TextEdit
@onready var text_edit2: LineEdit = $InputBox2/TextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (text_edit1.text).length()>=3:
		print(str(text_edit1.text.erase(0,2)))
		text_edit1.text=str(text_edit1.text.erase(0,2))
	if (text_edit2.text).length()>=3:
		text_edit2.text=str(text_edit1.text.erase(0,2))
