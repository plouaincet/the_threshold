extends CharacterBody2D
signal Light_Toggled
signal Door_Opened
@onready var progress: TextureProgressBar = $"../HUD2/SpeedBar/CenterContainer/ColorRect/MarginContainer/ProgressBar"
@onready var slots: HBoxContainer = $"../HUD2/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots"
@onready var playersprite: AnimatedSprite2D = $Sprite2D
@onready var game: Node2D = $".."
@onready var walking: AudioStreamPlayer2D = $"../Sounds/Walking"
@onready var vent_minigame: CanvasLayer = $"../VentMinigame"
@onready var safe_minigame: CanvasLayer = $"../SafeMinigame"

var BASE_SPEED: float = 60.6
const SPRINT_SPEED_BONUS: float = 30.0

const MAX_STAMINA: float = 100.0
const DRAIN_TIME: float = 2.0 #seconds to fully drain while sprinting
const DRAIN_RATE: float = MAX_STAMINA / DRAIN_TIME
const REGEN_RATE: float = DRAIN_RATE / 3.0
var stamina: float = MAX_STAMINA
var is_sprinting: bool = false
var lantern_open: bool = true
var exhausted: bool = false
var anim
var nearby_interactables: Array[Interactable] = []
var nearby_graffities: Array[Graffiti] =[]
var nearby_doors: Array[Doors] = []
func _physics_process(delta: float) -> void:
	var wants_to_sprint := Input.is_action_pressed("sprint")

	# Clear exhaustion once the player releases the key.
	if exhausted and not wants_to_sprint:
		exhausted = false

	is_sprinting = wants_to_sprint and not exhausted and stamina > 0.0

	if is_sprinting:
		playersprite.speed_scale=1.3
		walking.pitch_scale = 1
		stamina = max(0.0, stamina - DRAIN_RATE * delta)
		if stamina == 0.0:
			exhausted = true
	else:
		playersprite.speed_scale=1
		walking.pitch_scale = 0.8
		stamina = min(MAX_STAMINA, stamina + REGEN_RATE * delta)

	progress.value = stamina
	var current_speed: float = BASE_SPEED + (SPRINT_SPEED_BONUS if is_sprinting else 0.0)
	#print(is_sprinting, " ", stamina)
	var direction := Input.get_vector("left","right","up","down")
	velocity = direction * current_speed
	if not restrained():
		if velocity==Vector2.ZERO:
			walking.stop()
		elif not walking.is_playing():
			walking.play()
	else:
		walking.stop()

	if direction == Vector2(0,0):
		anim=playersprite.animation.erase(0,8)
		anim="idleeee_"+anim
		playersprite.play(anim)
	else:
		if direction.x==0 and direction.y!=0:
			anim=playersprite.animation.erase(0,8)
			anim="running_"+anim
			playersprite.play(anim)
		else:
			if direction.x>0:
				playersprite.play("running_right")
			elif direction.x<0:
				playersprite.play("running_left")

	if Input.is_action_just_pressed("light_toggle") and not restrained():
		emit_signal("Light_Toggled")
		lantern_open = not lantern_open
		
	if not restrained():
		move_and_slide()
		
func restrained() -> bool:
	if vent_minigame.visible or safe_minigame.visible:
		return true
	return false

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Interactable:
		nearby_interactables.append(area.get_parent())
		return
	if area.get_parent() is Doors:
		nearby_doors.append(area.get_parent())
		return
	if area.get_parent() is Graffiti:
		nearby_graffities.append(area.get_parent())
		return

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Interactable:
		nearby_interactables.erase(area.get_parent())
	if area.get_parent() is Doors:
		nearby_doors.erase(area.get_parent())
	if area.get_parent() is Graffiti:
		nearby_graffities.erase(area.get_parent())

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		print("slots: ",game.Slots)
		try_interact()

func try_interact():
	if not lantern_open:
		return

	if nearby_interactables.is_empty() and nearby_doors.is_empty() and nearby_graffities.is_empty():
		return
	if !nearby_interactables.is_empty():
		nearby_interactables[0].interact(self)
	if !nearby_doors.is_empty():
		nearby_doors[0].open(self)
		emit_signal("Door_Opened")
	if !nearby_graffities.is_empty():
		nearby_graffities[0].wipe(self)
