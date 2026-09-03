extends CanvasLayer
var fade_tween: Tween
@onready var bg: TextureRect = $Control/CenterContainer/Bg
@onready var key: TextureButton = $Control/CenterContainer/Bg/CenterContainer/Key
@onready var purple_wire: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/PurpleWire
@onready var yellow_wire: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/YellowWire
@onready var green_wire: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/GreenWire
@onready var red_wire: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/RedWire
@onready var blue_wire: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/BlueWire
@onready var grid: TextureRect = $Control/CenterContainer/Bg/CenterContainer2/Grid
@onready var cui_dr_jos: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/CuiDrJos
@onready var cui_dr_sus: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/CuiDrSus
@onready var cui_st_jos: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/CuiStJos
@onready var cui_st_sus: TextureButton = $Control/CenterContainer/Bg/CenterContainer2/CuiStSus
@onready var HUD2: TextureRect = $"../HUD2/PlayerKeys/CenterContainer/Control/MarginContainer/HBoxContainer/Kslot1/TextureRect"
@onready var vent: StaticBody2D= $"../Objects/Vent"
@onready var game: Node2D = $".."

var nrcuie:int=0
var allow_key:bool=false
var cursor_sprite: Sprite2D
var wires: Array[bool]=[true,true,true,true,true,true]
#blue
#red
#green
#yellow
#purple
var my_cursor = load("res://sprites/clips_cursor.png")
var finished_cutting:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_click_mask_from_texture(cui_dr_jos)
	set_click_mask_from_texture(cui_dr_sus)
	set_click_mask_from_texture(cui_st_jos)
	set_click_mask_from_texture(cui_st_sus)
	set_click_mask_from_texture(purple_wire)
	set_click_mask_from_texture(yellow_wire)
	set_click_mask_from_texture(green_wire)
	set_click_mask_from_texture(red_wire)
	set_click_mask_from_texture(blue_wire)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if cursor_sprite:
		cursor_sprite.global_position = get_viewport().get_mouse_position()

func _on_cui_st_sus_button_down() -> void:
	fade_out_cui(cui_st_sus)
	nrcuie+=1
	fade_out_grid(nrcuie>=4)
func _on_cui_st_jos_button_down() -> void:
	fade_out_cui(cui_st_jos)
	nrcuie+=1
	fade_out_grid(nrcuie>=4)
func _on_cui_dr_jos_button_down() -> void:
	fade_out_cui(cui_dr_jos)
	nrcuie+=1
	fade_out_grid(nrcuie>=4)
func _on_cui_dr_sus_button_down() -> void:
	fade_out_cui(cui_dr_sus)
	nrcuie+=1
	fade_out_grid(nrcuie>=4)

func fade_out_cui(cui:TextureButton) -> void:
	cui.disabled=true
	cui.offset_transform_enabled=true
	match cui.name:
		"CuiDrJos":
			cui.offset_transform_pivot=Vector2(143,143.4)
		"CuiDrSus":
			cui.offset_transform_pivot=Vector2(143,-143.4)
		"CuiStSus":
			cui.offset_transform_pivot=Vector2(-143,-143.4)
		"CuiStJos":
			cui.offset_transform_pivot=Vector2(-143,143.4)

	fade_tween = create_tween()
	fade_tween.tween_property(cui, "offset_transform_rotation", TAU, 0.4)
	fade_tween.tween_callback(func():
		match cui.name:
			"CuiDrJos":
				cui.offset_transform_pivot=Vector2(130,130)
			"CuiDrSus":
				cui.offset_transform_pivot=Vector2(130,-130)
			"CuiStSus":
				cui.offset_transform_pivot=Vector2(-130,-130)
			"CuiStJos":
				cui.offset_transform_pivot=Vector2(-130,130)
	)
	fade_tween.tween_property(cui, "offset_transform_scale", Vector2(3,3), 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	fade_tween.tween_property(cui, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(cui.queue_free)

func set_click_mask_from_texture(button: TextureButton) -> void:
	var image := button.texture_normal.get_image()
	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(image)
	button.texture_click_mask = bitmap

func fade_out_grid(state:bool):
	if state:
		await get_tree().create_timer(0.5).timeout
		fade_tween = create_tween()
		fade_tween.tween_property(grid, "modulate:a", 0.0, 0.5)
		fade_tween.tween_callback(grid.queue_free)
		change_cursor()
		wires[0]=false

func change_cursor() -> void:
	'''var hotspot := Vector2(1, 1)
	Input.set_custom_mouse_cursor(my_cursor, Input.CURSOR_ARROW, hotspot)'''
	vent.custom_cursor=true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	cursor_sprite = Sprite2D.new()
	cursor_sprite.texture = my_cursor
	cursor_sprite.scale = Vector2(0.5, 0.5)
	cursor_sprite.z_index = 67
	cursor_sprite.offset=Vector2(0,30)
	add_child(cursor_sprite)
	
func _on_blue_wire_button_down() -> void:
	if wires[0]==true:  
		return
	wires[1]=false
	fade_out_wire(blue_wire)

func _on_red_wire_pressed() -> void:
	for i in range(0,2):
		if wires[i]==true:
			return
	wires[2]=false
	fade_out_wire(red_wire)

func _on_green_wire_pressed() -> void:
	for i in range(0,3):
		if wires[i]==true:
			return
	wires[3]=false
	fade_out_wire(green_wire)

func _on_yellow_wire_pressed() -> void:
	for i in range(0,3):
		if wires[i]==true:
			return
	wires[4]=false
	fade_out_wire(yellow_wire)

func _on_purple_wire_pressed() -> void:
	for i in range(0,5):
		if wires[i]==true:
			return
	wires[5]=false
	fade_out_wire(purple_wire)
	vent.custom_cursor=false
	finished_cutting=true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for i in get_children():
		if i is Sprite2D:
			i.queue_free()
			allow_key=true

func fade_out_wire(wire:TextureButton) -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(wire, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(wire.queue_free)

func fade_out_bg(bgg: TextureRect) -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(bgg, "modulate:a", 0.0, 0.5)
	vent.flg=true
	fade_tween.tween_callback(func():
		visible = false
		bgg.modulate.a = 1.0)
	
func _on_key_button_down() -> void:
	HUD2.visible=true
	fade_out_wire(key)
	fade_out_bg(bg)
	game.et2_get_green_key()
	
