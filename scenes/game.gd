extends Node
@onready var player: CharacterBody2D = $player
@onready var enemy: CharacterBody2D = %Enemy
@onready var point_light_2d: PointLight2D = $player/PointLight2D
@onready var label: Label = $HUD/Text/CenterContainer/Label
@onready var chasing_music: AudioStreamPlayer2D = $Sounds/Chasing_Music
@onready var screenent_sound: AudioStreamPlayer2D = $Sounds/Screen_Entered_By_Enemy
@onready var inventory: Control = $"./HUD/PlayerInventory"
@onready var bg_music: AudioStreamPlayer2D = $Sounds/BgMusic
@onready var objects_node: Node2D = $Objects


var chours: int = 0
var cminutes: int = 0
const SCREEN_SIZE := Vector2(1152, 648)
const INDICATOR_SPEED := 500.0
const INDICATOR_MARGIN := 0
const CHASE_MUSIC_VOLUME := 0.0
var flg:bool=1

var Pink_Door1: bool =true
var Pink_Door2: bool=true
var Blue_Door: bool =true
var Orange_Door1: bool=true
var Orange_Door2: bool =true
var Purple_Door1: bool=true
var Purple_Door2: bool =true

var Purple_Doors: int = 4
var Orange_Doors: int = 2
var Pink_Doors: int = 2
var Blue_Doors: int = 1
var White_Doors: int = 1

var is_chasing: bool = false
var fade_tween: Tween
var indicator_pos := 0.0
var light_state: bool = true

var selected_frame:int=-1

var Slots: Array[String] = ["null","null","null","null","null"]
var Chairs: Array[String] = ["null","null","null","null","null","null","null","null"]

func _ready() -> void:
	bg_music.volume_db=5
	bg_music.play()
	player.Light_Toggled.connect(light_toggled)
	enemy.Enemy_Chasing.connect(_chasing_handle)
	player.Door_Opened.connect(_check_doors)
	randomise_clock()

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

func _handle_doors(_door_name: String) -> void:
	pass
		
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


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	screenent_sound.play()

func _check_doors() -> void:
	#print(White_Doors,Blue_Doors,Pink_Doors,Orange_Doors,Purple_Doors)
	if Pink_Door1==false:
		%TileMap/PinkDoor1.navigation_enabled=true
	if Pink_Door2==false:
		%TileMap/PinkDoor2.navigation_enabled=true
	if Blue_Door==false:
		%TileMap/BlueDoor.navigation_enabled=true
	if Orange_Door1==false:
		%TileMap/OrangeDoor1.navigation_enabled=true
	if Orange_Door2==false:
		%TileMap/OrangeDoor2.navigation_enabled=true
	if Purple_Door1==false:
		%TileMap/PurpleDoor1.navigation_enabled=true
	if Purple_Door2==false:
		%TileMap/PurpleDoor2.navigation_enabled=true

	if !Pink_Doors and !Blue_Doors and flg:
		enemy.patrol_points.insert(4,Vector2(539, -307))
		enemy.patrol_points.insert(5,Vector2(407, -20))
		flg=0

func add_object(img: Sprite2D, sname: String,pos:Vector2) -> bool:
	for i in range(Slots.size()):
		if Slots[i] == "null":
			Slots[i] = sname
			var slot = get_node("./HUD/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(i + 1))
			img.reparent(slot)
			img.position = slot.size / 2
			img.scale = Vector2(1.3, 1.3)
			inventory.frames[i].visible = false
			return true

	if selected_frame < 0:
		slot_spaces_shake()
		return false
	if Slots[selected_frame] == "null":
		return false

	#drop the old item into the maps
	var item_name: String = Slots[selected_frame]
	var scene_name := get_scene_name_for_item(item_name)
	var scene_path := "res://scenes/" + scene_name + ".tscn"  # adjust folder to your actual path

	if not ResourceLoader.exists(scene_path):
		print("No scene found at: ", scene_path)
		return false

	var packed: PackedScene = load(scene_path)
	var instance := packed.instantiate()
	instance.name = item_name
	objects_node.add_child(instance)
	instance.global_position = pos

	#remove the old items leftover sprite from the slot
	var slott := get_node("./HUD/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(selected_frame + 1))
	for child in slott.get_children():
		if child is Sprite2D:
			child.queue_free()

	#put the new pickedup item into the now empty slot
	Slots[selected_frame] = sname
	img.reparent(slott)
	img.position = slott.size / 2
	img.scale = Vector2(1.3, 1.3)
	inventory.frames[selected_frame].visible = true

	return true

func slot_spaces_shake() -> void:
	var original_pos: Vector2 = inventory.position
	var shake_amount: float = 6.0
	var shake_time: float = 0.0625

	var tween := create_tween()
	tween.tween_property(inventory, "position:x", original_pos.x - shake_amount, shake_time)
	tween.tween_property(inventory, "position:x", original_pos.x + shake_amount, shake_time)
	tween.tween_property(inventory, "position:x", original_pos.x - shake_amount, shake_time)
	tween.tween_property(inventory, "position:x", original_pos.x, shake_time)

func randomise_clock() -> void:
	chours = randi_range(0, 300)
	cminutes = randi_range(0, 1000)
	print("hours: ",chours)
	print("minutes: ",cminutes)

func get_scene_name_for_item(item_name: String) -> String:
	var regex := RegEx.new()
	regex.compile("^([A-Za-z]+)(\\d*)$")
	var result := regex.search(item_name)
	if result == null:
		return item_name.to_lower()

	var letters := result.get_string(1)
	var digits := result.get_string(2)

	if digits != "":
		return letters.to_lower() + "_" + digits
	else:
		return letters[0].to_lower() + letters.substr(1)
