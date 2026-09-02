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
var selected_frame:int=-1
var Slots: Array[String] = ["null","null","null","null","null"]
var keys: Array[bool] = [false,false,false,false,false,false,false]
var doors: Array[bool] = [false,true,true,true,true,true,true]
const CHASE_MUSIC_VOLUME := 0.0
var light_state: bool = true
var fade_tween: Tween
var is_chasing: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position=Vector2(0,0)
	enemy.global_position=Vector2(-1200,-400)
	bg_music.volume_db=5
	bg_music.play(scene_manager.music_position)
	player.Light_Toggled.connect(light_toggled)
	enemy.Enemy_Chasing.connect(_chasing_handle)
	player.Door_Opened.connect(_check_doors)


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

	if selected_frame < 0:
		slot_spaces_shake()
		return false
	if Slots[selected_frame] == "null":
		return false
	return false
