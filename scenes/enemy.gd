extends CharacterBody2D
@onready var player: CharacterBody2D = %player
@onready var timer: Timer = $Timer
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var vision: ShapeCast2D = $ShapeCast2D
@onready var vision2: ShapeCast2D = $ShapeCast2
@onready var vision3: ShapeCast2D = $ShapeCast3
@onready var game: Node = $".."
@onready var area_w_o_light: Area2D = $"Area w_o light"
@onready var area_w_light: Area2D = $"Area w light"
signal Enemy_Chasing
var map_synced: bool = false
@onready var bg_music: AudioStreamPlayer2D = $"../Sounds/BgMusic"
var spotted_by_enemy: bool = false
var spotted_by_enemy_forced: bool = false
var patrol_points: Array[Vector2] = [
	 Vector2(-584, -721),
	 Vector2(-400, -677),
	 Vector2(452, -614),
	 Vector2(621, -534),
	 Vector2(181, -330), 
	 Vector2(-525, -325),
	 Vector2(-584, -721),	
	]
var SPEED :int = 30
var current_patrol_index: int = 0
var target: CharacterBody2D = null
var max_view_distance := 500
var view_angle := deg_to_rad(70.0)

func _ready() -> void:
	for cast in [vision, vision2, vision3]:
		cast.shape.radius = 2.0
		cast.enabled = true
	vision.target_position = Vector2.UP * max_view_distance
	if patrol_points.size() > 0: 
		set_next_patrol_point()
	timer.start()
	NavigationServer2D.map_changed.connect(_on_map_changed)
	
func _on_map_changed(_map_rid: RID) -> void:
	map_synced = true

func _physics_process(_delta):
	for cast in [vision, vision2, vision3]:
		cast.shape.radius += 3.0
		if cast.shape.radius > 90.0:
			cast.shape.radius = 2.0

	check_player_inside()
	if spotted_by_enemy or spotted_by_enemy_forced: 
		SPEED=60
		emit_signal("Enemy_Chasing")
		nav.target_position = player.global_position 
		if abs(global_position-player.global_position).length()<=25:
			catch_player() 
			return
	else:
		SPEED = 30
		if not is_position_navigable(nav.target_position):
			set_next_patrol_point()
		elif nav.is_target_reached():
			set_next_patrol_point()
	
	if !nav.is_target_reached():
		var dir = (nav.get_next_path_position() - global_position).normalized()
		velocity = dir * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	update_vision()
	check_for_player()

func set_next_patrol_point() -> void:
	if patrol_points.is_empty():
		velocity = Vector2.ZERO
		return
	nav.target_position = patrol_points[current_patrol_index]
	
	current_patrol_index += 1
	
	if current_patrol_index >= patrol_points.size():
		current_patrol_index = 0

func catch_player() -> void:
	velocity = Vector2.ZERO
	get_tree().reload_current_scene()

func update_vision():
	if velocity.length() < 1:
		return
	var facing = velocity.normalized()
	# Center ray + two edge rays, spread across the full view_angle
	vision.target_position = facing * max_view_distance
	vision2.target_position = facing.rotated(-view_angle / 2.0) * max_view_distance
	vision3.target_position = facing.rotated(view_angle / 2.0) * max_view_distance
	vision.force_shapecast_update()
	vision2.force_shapecast_update()
	vision3.force_shapecast_update()

func check_for_player():
	target = null
	spotted_by_enemy = false
	if velocity.length() < 1:
		return
	var facing = velocity.normalized()
	var triangle_angle := Vector2.DOWN.angle_to(facing)
	$"Area w light/CollisionPolygon2D".rotation = triangle_angle

	for cast in [vision, vision2, vision3]:
		if cast.get_collision_count() == 0:
			continue
		var collider = cast.get_collider(0)
		if collider != player:
			continue # something else is closer along this ray, blocked

		var to_player = player.global_position - global_position
		if to_player.length() > max_view_distance:
			continue

		var angle = facing.angle_to(to_player.normalized())
		if abs(angle) <= view_angle / 2.0:
			target = player
			spotted_by_enemy = true
			return


func check_player_inside() -> void:
	if area_w_o_light.check_for_player() or area_w_light.check_for_player():
		spotted_by_enemy_forced=true
	else:
		spotted_by_enemy_forced=false

func is_chasing() -> bool:
	return spotted_by_enemy or spotted_by_enemy_forced

func is_position_navigable(pos: Vector2, tolerance: float = 16.0) -> bool:
	if not map_synced:
		return true
	var map_rid := nav.get_navigation_map()
	var closest_point := NavigationServer2D.map_get_closest_point(map_rid, pos)
	return closest_point.distance_to(pos) <= tolerance

func _on_enemy_is_close_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		bg_music.volume_db=-5

func _on_enemy_is_close_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		bg_music.volume_db=5
