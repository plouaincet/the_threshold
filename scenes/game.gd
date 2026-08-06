extends Node
@onready var player: CharacterBody2D = $player
@onready var point_light_2d: PointLight2D = $player/PointLight2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.Light_Toggled.connect(light_toggled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func light_toggled() -> void:
	point_light_2d.enabled= not point_light_2d.enabled
