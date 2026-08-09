extends Node
@onready var player: CharacterBody2D = $player
@onready var enemy: CharacterBody2D = %Enemy
@onready var point_light_2d: PointLight2D = $player/PointLight2D
@onready var label: Label = $HUD/Control/Label
@onready var chasing_music: AudioStreamPlayer2D = $Chasing_Music
@onready var screenent_sound: AudioStreamPlayer2D = $Screen_Entered_By_Enemy

const SCREEN_SIZE := Vector2(1152, 648)
const INDICATOR_SPEED := 500.0
const INDICATOR_MARGIN := 0
const CHASE_MUSIC_VOLUME := 0.0
var indicator_pos := 0.0
var light_state: bool = true
var Purple_Doors: bool = false
var Orange_Doors: bool = false
var Pink_Doors: bool = false
var Blue_Door: bool = false
var White_Door: bool = false
var is_chasing: bool = false
var fade_tween: Tween

func _ready() -> void:
	player.Light_Toggled.connect(light_toggled)
	enemy.Enemy_Chasing.connect(_chasing_handle)

func _process(_delta: float) -> void:
	if !enemy.is_chasing() and is_chasing and (abs(enemy.global_position.y - player.global_position.y) >= 200 or abs(enemy.global_position.x - player.global_position.x) >= 200):
		player.SPEED=75
		_fade_out_chase_music()
		is_chasing = false

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

func _handle_doors(_door_name: String) -> void:
	pass
		
func _chasing_handle() -> void:
	player.SPEED=80
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
