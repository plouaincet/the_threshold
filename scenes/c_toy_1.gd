extends Chair

@onready var game: Node2D = $"../.."
@onready var chair_minigame: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func place(_player: Node) -> void:
	var toy_name=name.erase(0,1)
	var cnt=0
	for i in game.Slots:
		cnt+=1
		if i == toy_name:
			var sprite=get_node("../../HUD/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(cnt) + "/Sprite2D")
			sprite.reparent(self)
			sprite.position = Vector2.ZERO
			sprite.scale = Vector2(0.5, 0.5)
			game.Slots[cnt-1]="null"
			check_for_completion()
			return
	game.slot_spaces_shake()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func check_for_completion() -> void:
	for i in chair_minigame.get_children():
		if i.get_child_count()==1:
			return
	print("you got orange key")
