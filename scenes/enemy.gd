extends CharacterBody2D
@onready var player: CharacterBody2D = %player
@onready var timer: Timer = $Timer
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var game: Node = $".."
@onready var area_w_o_light: Area2D = $"Area w_o light"
@onready var area_w_light: Area2D = $"Area w light"
signal Enemy_Chasing
var map_synced: bool = false
@onready var bg_music: AudioStreamPlayer2D = $"../Sounds/BgMusic"
var spotted_by_enemy: bool = false
var spotted_by_enemy_forced: bool = false
var forced_chase: bool = false
var forced_chase_lose_distance: float = 200.0
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

var ray_count: int = 15
var vision_rays: Array[RayCast2D] = []

func _ready() -> void:
	vision_rays.clear()
	for i in range(ray_count):
		vision_rays.append(_make_vision_ray())

	if patrol_points.size() > 0: 
		set_next_patrol_point()
	timer.start()
	NavigationServer2D.map_changed.connect(_on_map_changed)

func _make_vision_ray() -> RayCast2D:
	var ray := RayCast2D.new()
	ray.enabled = true
	ray.collide_with_bodies = true
	ray.collide_with_areas = true
	ray.exclude_parent = true
	ray.collision_mask = 1 | (1 << 4)  # layer 1 (walls) + layer 5 (PlayerVision) — adjust bits as needed
	add_child(ray)
	return ray

func _on_map_changed(_map_rid: RID) -> void:
	map_synced = true

func spawn_enemy_chase() -> void:
	global_position = Vector2(437, -488)
	forced_chase = true

func _physics_process(_delta):
	check_player_inside()
	check_for_player()
	if forced_chase:
		if game.Pink_Doors == 0:
			if not spotted_by_enemy and not spotted_by_enemy_forced:
				var diff = global_position - player.global_position
				if abs(diff.x) >= forced_chase_lose_distance or abs(diff.y) >= forced_chase_lose_distance:
					forced_chase = false
	if spotted_by_enemy or spotted_by_enemy_forced or forced_chase:
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

	if ray_count == 1:
		vision_rays[0].target_position = facing * max_view_distance
	else:
		for i in range(ray_count):
			# Spread rays evenly from -view_angle/2 to +view_angle/2
			var t = float(i) / float(ray_count - 1)  # 0.0 to 1.0
			var angle_offset = lerp(-view_angle / 2.0, view_angle / 2.0, t)
			vision_rays[i].target_position = facing.rotated(angle_offset) * max_view_distance

	for ray in vision_rays:
		ray.force_raycast_update()

func check_for_player():
	target = null
	spotted_by_enemy = false
	if velocity.length() < 1:
		return
	var facing = velocity.normalized()
	var triangle_angle := Vector2.DOWN.angle_to(facing)
	$"Area w light/CollisionPolygon2D".rotation = triangle_angle

	for ray in vision_rays:
		if not ray.is_colliding():
			continue
		var collider = ray.get_collider()
		'''if collider.name!="Collisions (do not open)":
			print(collider)'''
		var hit_player: bool = (collider == player) or (collider.get_parent() == player)
		if not hit_player:
			continue
		print(hit_player)

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
	return spotted_by_enemy or spotted_by_enemy_forced or forced_chase

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
