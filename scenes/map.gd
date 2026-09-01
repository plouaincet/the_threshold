extends Node2D
@onready var player: CharacterBody2D = %player
@onready var enemy: CharacterBody2D = %Enemy
@onready var CorridorEntrance: StaticBody2D = $"../Doors/Door10"
@onready var CorridorExit: StaticBody2D = $"../Doors/Door8"
@onready var CorridorExitArea: Area2D = $"../Doors/Door8/Area2D"
@onready var CorridorExitAreaCollision: CollisionShape2D = $"../Doors/Door8/Area2D/CollisionShape2D"
@onready var CorridorEntranceArea: Area2D = $"../Doors/Door10/Area2D"
@onready var CorridorEntranceAreaCollision: CollisionShape2D = $"../Doors/Door10/Area2D/CollisionShape2D"
@onready var game: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_corridor_entrance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemy._change_vision_ray(false)
		enemy.stop_chase = true
		CorridorEntranceArea.set_deferred("monitorable", false)
		CorridorEntranceAreaCollision.set_deferred("disabled", true)
		CorridorEntrance.come_back()


func _on_corridor_exit_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		enemy._change_vision_ray(true)
		enemy.stop_chase = false
		CorridorExitArea.set_deferred("monitorable", false)
		CorridorExitAreaCollision.set_deferred("disabled", true)
		CorridorExit.come_back()


func _on_map_exit_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		game.won()
