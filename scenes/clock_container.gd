extends CenterContainer
@onready var clock_hand_2: TextureRect = $ClockHand1
@onready var clock_hand_1: TextureRect = $ClockHand2
@onready var input_space: HBoxContainer = $"../../InputSpace"
@onready var timer: Timer = $Timer
@onready var clock_minigame: CanvasLayer = $"../../../../../../.."
@onready var game: Node2D = $"../../../../../../../.."
var actual_hours:int=0
var actual_minutes:int=0
var angles: Array[Vector2] = [
	Vector2(0, 0),
	Vector2(1, 40),
	Vector2(2, 65),
	Vector2(3, 90),
	Vector2(4, 115),
	Vector2(5, 147),
	Vector2(6, 180),
	Vector2(7, 210),
	Vector2(8, 242),
	Vector2(9, 270),
	Vector2(10, 295),
	Vector2(11, 325),
]

func _ready() -> void:
	timer.start(1.0)
func _process(delta: float) -> void:
	pass

func _handle_hands(time2:int, time1:int) -> void:
	#print("minute: ", time1)
	#print("hour: ", time2)
	clock_hand_2.offset_transform_rotation = deg_to_rad(get_minute_rotation(time1))
	clock_hand_1.offset_transform_rotation = deg_to_rad(_apply_offset(get_hour_rotation(time2, time1)))

func _apply_offset(angle: float) -> float:
	#shift back by 90
	return fmod(fmod(angle - 90.0, 360.0) + 360.0, 360.0)

func get_minute_rotation(minute: int) -> float:
	var lo := 0
	var hi := angles.size() - 1
	while lo < hi:
		var mid := (lo + hi + 1) / 2
		if angles[mid].x * 5 <= minute:
			lo = mid
		else:
			hi = mid - 1
	var lower: Vector2 = angles[lo]
	var upper: Vector2 = angles[(lo + 1) % angles.size()]
	var lower_minute: int = int(lower.x * 5)
	var upper_minute: int = int(upper.x * 5)
	if upper_minute <= lower_minute:
		upper_minute += 60
	var lower_angle: float = lower.y
	var upper_angle: float = upper.y
	if upper_angle <= lower_angle:
		upper_angle += 360
	var t: float = float(minute - lower_minute) / float(upper_minute - lower_minute)
	return fmod(lower_angle + (upper_angle - lower_angle) * t, 360.0)

func get_hour_rotation(hour: int, minute: int) -> float:
	var search_hour: int = hour % 12
	var lo := 0
	var hi := angles.size() - 1
	while lo < hi:
		var mid := (lo + hi) / 2
		if int(angles[mid].x) == search_hour:
			lo = mid
			hi = mid
		elif int(angles[mid].x) < search_hour:
			lo = mid + 1
		else:
			hi = mid - 1
	var current: Vector2 = angles[lo]
	var next_entry: Vector2 = angles[(lo + 1) % angles.size()]
	var lower_angle: float = current.y
	var upper_angle: float = next_entry.y
	if upper_angle <= lower_angle:
		upper_angle += 360
	var t: float = float(minute) / 60.0
	return fmod(lower_angle + (upper_angle - lower_angle) * t, 360.0)


func _on_timer_timeout() -> void:
	if clock_minigame.visible==true:
		var hours:int
		var minutes:int
		if $"../../InputSpace/InputBox1/TextEdit1".text == null:
			hours=0
		else: 
			hours=int($"../../InputSpace/InputBox1/TextEdit1".text)
		if $"../../InputSpace/InputBox2/TextEdit2".text==null:
			minutes=0
		else:
			minutes=int($"../../InputSpace/InputBox2/TextEdit2".text)
		_handle_hands(hours,minutes)
	timer.start()


func _on_texture_button_pressed() -> void:
	print("hi")
	if clock_minigame.visible==true:
		var hours:int
		var minutes:int
		if $"../../InputSpace/InputBox1/Textdit1".text == null:
			hours=0
		else: 
			hours=int($"../../InputSpace/InputBox1/TextEdit1".text)
		if $"../../InputSpace/InputBox2/TextEdit2".text==null:
			minutes=0
		else:
			minutes=int($"../../InputSpace/InputBox2/TextEdit2".text)
			resolve_clock()
		if hours==actual_hours and minutes==actual_minutes:
			print("you got blue key")

func resolve_clock() -> void:
	actual_minutes=game.cminutes%60
	actual_hours=(game.chours%24+game.cminutes/60)%24
	print("actual hours: ",actual_hours)
	print("actual minutes: ",actual_minutes)
