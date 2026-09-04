extends CanvasLayer
@onready var game: Node2D = $".."
@onready var polygon_1: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/Control/Polygon2D
@onready var polygon_2: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/Control2/Polygon2D
@onready var polygon_3: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/Control3/Polygon2D
@onready var polygon_4: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/Control/Polygon2D
@onready var polygon_5: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/Control2/Polygon2D
@onready var polygon_6: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/Control3/Polygon2D
@onready var polygon_7: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer3/Control/Polygon2D
@onready var polygon_8: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer3/Control2/Polygon2D
@onready var polygon_9: Polygon2D = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer3/Control3/Polygon2D
@onready var center_container: CenterContainer = $CenterContainer
@onready var maner: TextureRect = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer/TextureRect
@onready var timer: Timer = $Timer
@onready var texture_rect: TextureRect = $CenterContainer/TextureRect/MarginContainer/HBoxContainer/CenterContainer2/TextureRect/MarginContainer/TextureRect
@onready var handle_pushed: AudioStreamPlayer2D = $HandlePushed
var fading:bool=false
var pressing_button:bool=false
var hovering: bool
var PIN:int=0
var fade_tween:Tween
var correct_pin:int=-1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible=false
	timer.start(0.05)
	print(PIN)
	correct_pin=game.pinnr
	polygon_1.modulate.a=0
	polygon_2.modulate.a=0
	polygon_3.modulate.a=0
	polygon_4.modulate.a=0
	polygon_5.modulate.a=0
	polygon_6.modulate.a=0
	polygon_7.modulate.a=0
	polygon_8.modulate.a=0
	polygon_9.modulate.a=0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(get_viewport().get_mouse_position())
	#print(pressing_button)
	pass

func _on_button_1_pressed() -> void:
	click(polygon_1)
	PIN=PIN*10+1
	if PIN>9999:
		PIN=PIN%10

func _on_button_2_pressed() -> void:
	click(polygon_2)
	PIN=PIN*10+2
	if PIN>9999:
		PIN=PIN%10

func _on_button_3_pressed() -> void:
	click(polygon_3)
	PIN=PIN*10+3
	if PIN>9999:
		PIN=PIN%10

func _on_button_4_pressed() -> void:
	click(polygon_4)
	PIN=PIN*10+4
	if PIN>9999:
		PIN=PIN%10

func _on_button_5_pressed() -> void:
	click(polygon_5)
	PIN=PIN*10+5
	if PIN>9999:
		PIN=PIN%10

func _on_button_6_pressed() -> void:
	click(polygon_6)
	PIN=PIN*10+6
	if PIN>9999:
		PIN=PIN%10

func _on_button_7_pressed() -> void:
	click(polygon_7)
	PIN=PIN*10+7
	if PIN>9999:
		PIN=PIN%10

func _on_button_8_pressed() -> void:
	click(polygon_8)
	PIN=PIN*10+8
	if PIN>9999:
		PIN=PIN%10

func _on_button_9_pressed() -> void:
	click(polygon_9)
	PIN=PIN*10+9
	if PIN>9999:
		PIN=PIN%10

func fade_out_safe() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(center_container, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(func(): visible=false)
func check_pin(pin: int) -> void:
	print("pressed",PIN)
	if pin==correct_pin and !fading:
		fade_out_game()
	else:
		PIN=0
func click(poly:Polygon2D) -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(poly, "modulate:a", 1.0, 0.1)
	fade_tween.tween_property(poly, "modulate:a", 0.0, 0.1)

func _on_timer_timeout() -> void:
	pressing_button= texture_rect.get_global_rect().has_point(get_viewport().get_mouse_position())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !pressing_button:
		var angle=rad_to_deg(Vector2(415,323).angle_to_point(get_viewport().get_mouse_position()))
		if angle>0 and angle<=60:
			maner.offset_transform_rotation=deg_to_rad(angle)
		elif angle<0:
			maner_move()
		elif angle>60:
			maner_move_down()
			check_pin(PIN)
		pass
	timer.start(0.05)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			if maner.offset_transform_rotation!=0 and maner.offset_transform_rotation!=TAU/6:
				await get_tree().create_timer(1).timeout
				slow_maner_move()

func maner_move() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(maner, "offset_transform_rotation", 0, 0.15)
func maner_move_down() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(maner, "offset_transform_rotation", TAU/6, 0.15)
	#fade_tween.tween_property(maner, "offset_transform_rotation", 0, 0.15)
func slow_maner_move() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(maner, "offset_transform_rotation", 0, 0.25)
func fade_out_game() -> void:
	fading=true
	handle_pushed.play()
	await get_tree().create_timer(2).timeout
	fade_tween = create_tween()
	fade_tween.tween_property(center_container, "modulate:a", 0, 0.5)
	fade_tween.tween_callback(func():
		visible=false
		center_container.modulate.a=1
		game.et2_get_red_key()
		)
