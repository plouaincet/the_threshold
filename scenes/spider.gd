extends StaticBody2D
@onready var point_light_2d: PointLight2D = $PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_light_2d.visible=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		point_light_2d.visible=true
		%HUD.get_node("Notfication").show_notification("Did you explore everything?")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		point_light_2d.visible=false
