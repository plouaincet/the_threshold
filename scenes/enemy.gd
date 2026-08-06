extends CharacterBody2D

@onready var player: CharacterBody2D = %player
@onready var timer: Timer = $Timer
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var vision: ShapeCast2D = $ShapeCast2D

const SPEED := 50

var target: CharacterBody2D = null

var max_view_distance := 500.0
var view_angle := deg_to_rad(30.0)

func _ready() -> void:
	nav.target_position = player.global_position

	vision.enabled = true
	vision.target_position = Vector2.UP * max_view_distance

	timer.start()
	
func _physics_process(_delta):

	if !nav.is_target_reached():
		var dir = (nav.get_next_path_position() - global_position).normalized()
		velocity = dir * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	update_vision()

	check_for_player()

func _on_timer_timeout():

	nav.target_position = player.global_position
	timer.start()

func update_vision():

	if velocity.length() < 1:
		return

	var facing = velocity.normalized()

	vision.target_position = facing * max_view_distance
	vision.force_shapecast_update()

func check_for_player():
	
	target = null
	#$"../Label".text = "NOT SEEN"
	if velocity.length() < 1:
		return

	var facing = velocity.normalized()

	for i in vision.get_collision_count():

		var collider = vision.get_collider(i)

		if collider != player:
			continue

		var to_player = player.global_position - global_position

		if to_player.length() > max_view_distance:
			continue

		var angle = facing.angle_to(to_player.normalized())

		if abs(angle) <= view_angle / 2.0:
			target = player
			print("PLAYER SEEN")
			#$"../Label".text="PLAYER SEEN"
			return
