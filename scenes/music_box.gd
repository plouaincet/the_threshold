extends StaticBody2D
@onready var line_2d: Line2D = $Line2D
@onready var game:Node2D = $"../.."
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var timer: Timer = $Timer
var crank_is_in:bool=false
@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer2D
signal quietdown(state:bool)
var play_position:float=0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.visible=false
	sprite_2d.play("idle")
	music.volume_db=5

func insert_clank() -> void:
	if game.Slots[game.selected_frame]=="Clank":
		game.Slots[game.selected_frame]="null"
		var slott := get_node("../../HUD/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(game.selected_frame + 1))
		for child in slott.get_children():
			if child is Sprite2D:
				child.queue_free()
		crank_is_in=true
		sprite_2d.play("playing")
		emit_signal("quietdown",true)
		music.play(play_position)
		timer.start(30.0)
		game.get_pink_key()
		return
	if crank_is_in:
		if sprite_2d.is_playing():
			emit_signal("quietdown",false)
			play_position=music.get_playback_position()
			music.stop()
			sprite_2d.pause()
			timer.stop()
		else:
			sprite_2d.play("playing")
			emit_signal("quietdown",true)
			timer.start(30.0)
			music.play(play_position)
			game.get_pink_key()
		return
	game.slot_spaces_shake()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=false


func _on_timer_timeout() -> void:
	sprite_2d.pause()
	emit_signal("quietdown",false)
	music.stop()
