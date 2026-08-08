extends Node
@onready var player: CharacterBody2D = $player
@onready var enemy: CharacterBody2D = %Enemy
@onready var point_light_2d: PointLight2D = $player/PointLight2D
@onready var label: Label = $HUD/Control/Label
@onready var label2: Label = $HUD/Control/Enemy_Chasing
@onready var rect: ColorRect = $HUD/Control/ColorRect
@onready var indicator: ColorRect = $"HUD/Control/ColorRect3"
const SCREEN_SIZE := Vector2(1152, 648)
const INDICATOR_SPEED := 500.0
const INDICATOR_MARGIN := 0 
var indicator_pos := 0.0
var light_state: bool = true
var Purple_Doors: bool = false
var Orange_Doors: bool = false
var Pink_Doors: bool = false
var Blue_Door: bool = false
var White_Door: bool = false

func _ready() -> void:
	player.Light_Toggled.connect(light_toggled)
	enemy.Enemy_Chasing.connect(_direction_handle)
	#player.Door_Opened.connect(_handle_doors)
	indicator.pivot_offset = indicator.size * 0.5
	indicator_pos = _point_to_perimeter_coord(
		_direction_to_edge_point((enemy.position - player.position).normalized(), _get_travel_rect()),
		_get_travel_rect()
	)

func _process(delta: float) -> void:
	_update_indicator(delta)

func light_toggled() -> void:
	point_light_2d.enabled = not point_light_2d.enabled
	if point_light_2d.enabled:
		$LightOn.play()
		label.text = "Toggle light OFF: Z"
		light_state = true
	else:
		$LightOff.play()
		label.text = "Toggle light ON: Z"
		light_state = false

func _handle_doors(door_name: String) -> void:
	pass

func _direction_handle() -> void:
	label2.visible = true
	rect.visible = true
	var difference := enemy.position - player.position
	var text: String
	if abs(difference.x) > abs(difference.y):
		if difference.x > 0:
			text = "TO YOUR RIGHT"
		else:
			text = "TO YOUR LEFT"
	else:
		if difference.y > 0:
			text = "TO YOUR BACK"
		else:
			text = "TO YOUR FRONT"
	if text != label2.text:
		label2.text = text
	await get_tree().create_timer(2.0).timeout
	label2.visible = false
	rect.visible = false

func _get_travel_rect() -> Rect2:
	var control := indicator.get_parent() as Control
	var area_size := control.size
	var thickness: float = min(indicator.size.x, indicator.size.y)
	var length: float = max(indicator.size.x, indicator.size.y)
	var along := length * 0.5 + INDICATOR_MARGIN

	return Rect2(Vector2(along, along), area_size - Vector2(along, along) * 2.0)

func _perim_thickness_inset() -> float:
	var thickness: float = min(indicator.size.x, indicator.size.y)
	return thickness * 0.5 + INDICATOR_MARGIN

func _direction_to_edge_point(dir: Vector2, travel_rect: Rect2) -> Vector2:
	var center := travel_rect.position + travel_rect.size * 0.5
	var half := travel_rect.size * 0.5
	if dir == Vector2.ZERO:
		return center + Vector2(half.x, 0)
	var tx := INF
	var ty := INF
	if dir.x != 0.0:
		tx = half.x / abs(dir.x)
	if dir.y != 0.0:
		ty = half.y / abs(dir.y)
	var t: float = min(tx, ty)
	return center + dir * t

func _point_to_perimeter_coord(point: Vector2, travel_rect: Rect2) -> float:
	var w := travel_rect.size.x
	var h := travel_rect.size.y
	var local := point - travel_rect.position
	local.x = clamp(local.x, 0.0, w)
	local.y = clamp(local.y, 0.0, h)
	var eps := 0.5
	if local.y <= eps:
		return local.x                              # top edge, left -> right
	elif local.x >= w - eps:
		return w + local.y                           # right edge, top -> bottom
	elif local.y >= h - eps:
		return w + h + (w - local.x)                 # bottom edge, right -> left
	else:
		return w + h + w + (h - local.y)              # left edge, bottom -> top
func _perimeter_coord_to_point(coord: float, travel_rect: Rect2) -> Vector2:
	var control := indicator.get_parent() as Control
	var full_size := control.size
	var perp := _perim_thickness_inset()

	var w := travel_rect.size.x
	var h := travel_rect.size.y
	var perimeter := 2.0 * (w + h)
	coord = fposmod(coord, perimeter)
	var p := travel_rect.position

	if coord <= w:
		return Vector2(p.x + coord, perp)                                  # top
	elif coord <= w + h:
		return Vector2(full_size.x - perp, p.y + (coord - w))              # right
	elif coord <= w + h + w:
		return Vector2(p.x + w - (coord - w - h), full_size.y - perp)      # bottom
	else:
		return Vector2(perp, p.y + h - (coord - w - h - w))                # left
func _perimeter_coord_to_rotation(coord: float, travel_rect: Rect2) -> float:
	var w := travel_rect.size.x
	var h := travel_rect.size.y
	var perimeter := 2.0 * (w + h)
	coord = fposmod(coord, perimeter)
	if coord <= w:
		return 0.0            # top
	elif coord <= w + h:
		return PI / 2.0       # right
	elif coord <= w + h + w:
		return PI             # bottom
	else:
		return -PI / 2.0      # left

func _update_indicator(delta: float) -> void:
	if not is_instance_valid(player) or not is_instance_valid(enemy):
		return
	var dir := enemy.position - player.position
	if dir.length() < 0.001:
		return # enemy is on top of player, direction is undefined, skip this frame

	var travel_rect := _get_travel_rect()
	var perimeter := 2.0 * (travel_rect.size.x + travel_rect.size.y)

	var target_point := _direction_to_edge_point(dir.normalized(), travel_rect)
	var target_coord := _point_to_perimeter_coord(target_point, travel_rect)

	# shortest signed distance around the ring (this is what decides
	# clockwise vs anticlockwise, following whichever way the enemy actually moved)
	var diff := fmod(target_coord - indicator_pos, perimeter)
	if diff > perimeter * 0.5:
		diff -= perimeter
	elif diff < -perimeter * 0.5:
		diff += perimeter

	var max_step := INDICATOR_SPEED * delta
	diff = clamp(diff, -max_step, max_step)
	indicator_pos = fposmod(indicator_pos + diff, perimeter)

	var point := _perimeter_coord_to_point(indicator_pos, travel_rect)
	indicator.position = point - indicator.size * 0.5
	indicator.rotation = _perimeter_coord_to_rotation(indicator_pos, travel_rect)
