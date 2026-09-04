extends Node2D

@onready var bg_music: AudioStreamPlayer2D = $Sounds/BgMusic
@onready var player: CharacterBody2D = %player
@onready var enemy: CharacterBody2D = %Enemy
@onready var point_light_2d: PointLight2D = $player/PointLight2D
@onready var label: Label = $HUD2/Text/CenterContainer/Label
@onready var chasing_music: AudioStreamPlayer2D = $Sounds/Chasing_Music
@onready var scene_manager: Node = $".."
@onready var enemy_map_2: Node2D = $EnemyMap2
@onready var map: Node2D = $Map2/HiddenAreas
@onready var inventory: Control = $"./HUD2/PlayerInventory"
@onready var playerkeys: Control = $"./HUD2/PlayerKeys"
@onready var kslot_1: TextureRect = $HUD2/PlayerKeys/CenterContainer/Control/MarginContainer/HBoxContainer/Kslot1/TextureRect
@onready var kslot_2: TextureRect = $HUD2/PlayerKeys/CenterContainer/Control/MarginContainer/HBoxContainer/Kslot2/TextureRect
@onready var kslot_3: TextureRect = $HUD2/PlayerKeys/CenterContainer/Control/MarginContainer/HBoxContainer/Kslot3/TextureRect
@onready var kslot_4: TextureRect = $HUD2/PlayerKeys/CenterContainer/Control/MarginContainer/HBoxContainer/Kslot4/TextureRect
@onready var notif: Control = $HUD2/Notfication
@onready var glabel: Label = $HUD2/GraffitiCounter/CenterContainer/Label
@onready var light: DirectionalLight2D = $DirectionalLight2D
@onready var eye: StaticBody2D = $ShowGraffities/Eye
@onready var g_armor: StaticBody2D = $ShowGraffities/GArmor
@onready var g_boot: StaticBody2D = $ShowGraffities/GBoot
@onready var g_glove: StaticBody2D = $ShowGraffities/GGlove
@onready var g_mask: StaticBody2D = $ShowGraffities/GMask
@onready var g_scut: StaticBody2D = $ShowGraffities/GScut
@onready var sword: StaticBody2D = $ShowGraffities/Sword
@onready var cape: StaticBody2D = $ShowGraffities/Cape
@onready var time: Label = $HUD2/Timer/CenterContainer/Label
var can_blue_key:bool=false

var LIGHTSHOW_tween:Tween
var pinnr:int=0
var selected_frame:int=-1
var Slots: Array[String] = ["null","null","null","null","null"]
var keys: Array[bool] = [false,0,0,false,false,false,false]
var doors: Array[bool] = [false,true,true,true,true,true,true]
const CHASE_MUSIC_VOLUME := 0.0
var light_state: bool = true
var fade_tween: Tween
var is_chasing: bool = false
var graffities:float=5.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position=Vector2(0,0)
	enemy.global_position=Vector2(-1200,-400)
	bg_music.volume_db=5
	bg_music.play(scene_manager.music_position)
	player.Light_Toggled.connect(light_toggled)
	enemy.Enemy_Chasing.connect(_chasing_handle)
	player.Door_Opened.connect(_check_doors)
	eye.visible=false
	g_armor.visible=false
	g_boot.visible=false
	g_glove.visible=false
	g_mask.visible=false
	g_scut.visible=false
	sword.visible=false
	cape.visible=false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		if !enemy.is_chasing() and is_chasing and (abs(enemy.global_position.y - player.global_position.y) >= 200 or abs(enemy.global_position.x - player.global_position.x) >= 200):
			player.BASE_SPEED=75
			_fade_out_chase_music()
			is_chasing = false

func light_toggled() -> void:
	point_light_2d.enabled = not point_light_2d.enabled
	if point_light_2d.enabled:
		$Sounds/LightOn.play()
		label.text = "Toggle light OFF: Z/Space"
		light_state = true
	else:
		$Sounds/LightOff.play()
		label.text = "Toggle light ON: Z/Space"
		light_state = false

		
func _chasing_handle() -> void:
	player.BASE_SPEED=80
	if !is_chasing:
		is_chasing = true
		if fade_tween and fade_tween.is_valid():
			fade_tween.kill()
		chasing_music.volume_db = CHASE_MUSIC_VOLUME
		chasing_music.play()

func _fade_out_chase_music() -> void:
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(chasing_music, "volume_db", -40.0, 1.0)
	fade_tween.tween_callback(chasing_music.stop)

func _check_doors() -> void:
	if !doors[3]:
		%EnemyMap2/RedDoor.enabled=true
		fade_out_black(map.get_node("Red_Door"))
	if !doors[4]:
		%EnemyMap2/RedDoor2.enabled=true
		fade_out_black(map.get_node("Red_Door2"))
	if !doors[1]:
		%EnemyMap2/GreenDoor.enabled=true
		fade_out_black(map.get_node("Green_Door"))
	if !doors[2]:
		%EnemyMap2/GreenDoor2.enabled=true
		fade_out_black(map.get_node("Green_Door2"))
	if !doors[6]:
		%EnemyMap2/WhiteDoor.enabled=true
		fade_out_black(map.get_node("White_Door"))
	if !doors[5]:
		%EnemyMap2/BlueDoor.enabled=true
		fade_out_black(map.get_node("Blue_Door"))

func fade_out_black(room:Polygon2D) -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(room, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(func(): room.visible = false)

func open_door(door_nr:int) -> void:
	doors[door_nr]=false

func slot_spaces_shake() -> void:
	var original_pos: Vector2 = inventory.position
	var shake_amount: float = 6.0
	var shake_time: float = 0.0625

	var tween := create_tween()
	tween.tween_property(inventory, "position:x", original_pos.x - shake_amount, shake_time)
	tween.tween_property(inventory, "position:x", original_pos.x + shake_amount, shake_time)
	tween.tween_property(inventory, "position:x", original_pos.x - shake_amount, shake_time)
	tween.tween_property(inventory, "position:x", original_pos.x, shake_time)

func playerkeys_spaces_shake() -> void:
	var original_pos: Vector2 = playerkeys.position
	var shake_amount: float = 6.0
	var shake_time: float = 0.0625

	var tween := create_tween()
	tween.tween_property(playerkeys, "position:x", original_pos.x - shake_amount, shake_time)
	tween.tween_property(playerkeys, "position:x", original_pos.x + shake_amount, shake_time)
	tween.tween_property(playerkeys, "position:x", original_pos.x - shake_amount, shake_time)
	tween.tween_property(playerkeys, "position:x", original_pos.x, shake_time)

func add_object(img: Sprite2D, sname: String) -> bool:
	for i in range(Slots.size()):
		if Slots[i] == "null":
			Slots[i] = sname
			var slot = get_node("./HUD2/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(i + 1))
			img.reparent(slot)
			img.position = slot.size / 2
			img.scale = Vector2(2, 2)
			inventory.frames[i].visible = false
			return true

	if selected_frame < 0 or Slots[selected_frame]=="null":
		slot_spaces_shake()
		return false
	return false

func et2_get_green_key() -> void:
	if !keys[1] and !keys[2]:
		keys[1]=true
		keys[2]=true
		notif.show_notification("You got the GREEN key.")
func et2_get_red_key() ->void:
	if !keys[3] and !keys[4]:
		keys[3]=true
		keys[4]=true
		kslot_2.visible=true
		notif.show_notification("You got the RED key.")
func et2_get_blue_key()-> void:
	if !keys[5]:
		keys[5]=true
		kslot_3.visible=true
		notif.show_notification("You got the BLUE key.")
		scene_manager.player_to_leaderboard()

func randomise_pin() -> String:
	var first_digit:int=randi_range(1,9)
	var second_digit:int=randi_range(1,9)
	var third_digit:int=randi_range(1,9)
	var fourth_digit:int=randi_range(1,9)
	var number:String=str(first_digit) + str(second_digit) + '\n' + str(third_digit) + str(fourth_digit)
	print("PIN IS: ",number)
	pinnr=int(first_digit)*1000+int(second_digit)*100+int(third_digit)*10+int(fourth_digit)
	return number

func remove_slot_obj() ->void:
	var slott := get_node("./HUD2/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(selected_frame + 1))
	for child in slott.get_children():
		if child is Sprite2D:
			child.queue_free()
func add_graffities(_GName:String,value:float) -> void:
	graffities+=value
	print(round(graffities))
	if abs(graffities - round(graffities)) < 0.001:
		glabel.text=str(int(round(graffities))) + "/8 Graffities"
	else:
		glabel.text=str(graffities) + "/8 Graffities"
	if abs(graffities - 8.0) < 0.001:
		#open white door basically
		pass
func light_show() -> void:
	if LIGHTSHOW_tween and LIGHTSHOW_tween.is_valid():
		LIGHTSHOW_tween.kill()

	LIGHTSHOW_tween = create_tween()
	LIGHTSHOW_tween.tween_property(light, "color:a", 0.0, 0.1)
	LIGHTSHOW_tween.tween_property(light, "color:a", 1.0, 0.1)
	LIGHTSHOW_tween.tween_property(light, "color:a", 0.0, 0.1)
	LIGHTSHOW_tween.tween_property(light, "color:a", 1.0, 0.1)
	LIGHTSHOW_tween.tween_interval(1.0)
	LIGHTSHOW_tween.tween_callback(func(): 
		light.color = Color8(75, 140, 75) 
		bg_music.volume_db-=5
		light.energy=2.5
		eye.visible=true
		g_armor.visible=true
		g_boot.visible=true
		g_glove.visible=true
		g_mask.visible=true
		g_scut.visible=true
		sword.visible=true
		cape.visible=true
		
		)
	LIGHTSHOW_tween.tween_property(light, "color:a", 0.0, 0.1)
	LIGHTSHOW_tween.tween_property(light, "color:a", 1.0, 0.1)
	can_blue_key=true
func turn_light_back() -> void:
	bg_music.volume_db=5
	if can_blue_key:
		et2_get_blue_key()
	eye.visible=false
	g_armor.visible=false
	g_boot.visible=false
	g_glove.visible=false
	g_mask.visible=false
	g_scut.visible=false
	sword.visible=false
	cape.visible=false
	light.energy=0.92
	light.color=Color8(255,255,255)

func _change_time(seconds:int) -> void:
	if seconds%60>9:
		@warning_ignore("integer_division")
		time.text=str(seconds/60) + ":" + str(seconds%60)
	else:
		@warning_ignore("integer_division")
		time.text=str(seconds/60) + ":0" + str(seconds%60)
