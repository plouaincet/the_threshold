extends Doors
var fade_tween: Tween
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var game: Node2D = $"../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func open(_player: Node) -> void:
	game.Purple_Doors-=1
	fade_out_door()

func fade_out_door() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(sprite_2d, "modulate:a", 0.0, 0.5)
	fade_tween.tween_callback(queue_free)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
