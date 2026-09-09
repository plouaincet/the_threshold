extends Control
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var music: AudioStreamPlayer2D = $Music
signal credits_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.volume_db = -40.0
	music.play(25.0)
	var fade_tween := create_tween()
	fade_tween.tween_property(music, "volume_db", 0.0, 2.0)
	
	v_box_container.position.y = 1200
	var tween := create_tween()
	tween.tween_property(v_box_container, "position:y", -2200, 30.0)
	tween.tween_callback(func(): credits_finished.emit())
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
