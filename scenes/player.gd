extends CharacterBody2D

signal Light_Toggled
#signal Door_Opened(Door_Opened: String) TODO: Later!!
var SPEED:int = 75
@onready var playersprite: AnimatedSprite2D = $Sprite2D
var nearby_interactables: Array[Interactable] = []
var anim
var lantern_open: bool =true

func ready(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left","right","up","down")
	velocity=direction*SPEED
	if direction==Vector2(0,0):
		anim=playersprite.animation.erase(0,8)
		anim="idleeee_"+anim
		playersprite.play(anim)
	elif direction.x==0 and direction.y!=0:
		anim=playersprite.animation.erase(0,8)
		anim="running_"+anim
		playersprite.play(anim)
	else:
		if direction.x>0:
			playersprite.play("running_right")
		elif direction.x<0:
			playersprite.play("running_left")
	if Input.is_action_just_pressed("light_toggle"):
		emit_signal("Light_Toggled")
		lantern_open = not lantern_open
	move_and_slide()
	

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Interactable:
		nearby_interactables.append(area.get_parent())


func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Interactable:
		nearby_interactables.erase(area.get_parent())

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		try_interact()

func try_interact():
	if not lantern_open:
		return

	if nearby_interactables.is_empty():
		return

	var object = nearby_interactables[0]
	object.interact(self)
