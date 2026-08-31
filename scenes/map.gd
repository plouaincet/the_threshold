extends Node2D
@onready var player: CharacterBody2D = %player
@onready var enemy: CharacterBody2D = %Enemy
@onready var CorridorEntrance: StaticBody2D = $"../Doors/Door10"
@onready var CorridorExit: StaticBody2D = $"../Doors/Door8"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_corridor_entrance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemy._change_vision_ray(false)
		enemy.stop_chase=true
		CorridorEntrance.come_back()


func _on_corridor_exit_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemy._change_vision_ray(true)
		enemy.stop_chase=false
		CorridorExit.come_back()
