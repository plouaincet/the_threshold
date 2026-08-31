extends Doors
var fade_tween: Tween
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var game: Node2D = $"../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func open(_player: Node) -> void:
	if game.purplekey:
		game.Purple_Doors-=1
		game.Purple_Door3=false
		fade_out_door()
		return
	game.playerkeys_spaces_shake()

func fade_out_door() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(sprite_2d, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(_change_collision)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _change_collision() -> void:
	collision_layer=10

func come_back() -> void:
	collision_layer=1
	sprite_2d.modulate.a=100
