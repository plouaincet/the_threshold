extends Chair

@onready var game: Node2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func place(_player: Node) -> void:
	var toy_name=name.erase(0,1)
	for i in game.Slots:
		if i == toy_name:
			game.add_sprite_to_chair()
			return
	game.slot_spaces_shake()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
