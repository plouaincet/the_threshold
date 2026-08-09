extends CharacterBody2D

signal Light_Toggled
#signal Door_Opened(Door_Opened: String) TODO: Later!!
var SPEED:int = 75
@onready var playersprite: AnimatedSprite2D = $Sprite2D

var anim

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
	move_and_slide()
	
	
