extends StaticBody2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var game: Node2D = $"../"
@onready var sprite_2d: Sprite2D = $Sprite2D

var fade_tween:Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_light_2d.visible=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		point_light_2d.visible=true
		%HUD.get_node("Notfication").show_notification("Did you explore everything?")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		point_light_2d.visible=false

func fade_out_spider() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(sprite_2d, "modulate:a", 0.0, 0.5)
	print("sters")
	fade_tween.tween_callback(queue_free)
