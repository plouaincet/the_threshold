extends Chair

@onready var game: Node2D = $"../.."
@onready var chair_minigame: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func place(_player: Node) -> void:
	if self.get_child_count() and self.get_child(1) is Sprite2D:
		pick_up()
		return
	#var toy_name=name.erase(0,1)
	var cnt=game.selected_frame
	if cnt+1 and game.Slots[cnt]!="null" and game.Chairs[int(name.erase(0,3))-1]:  #and game.Slots[cnt] == toy_name
		cnt+=1
		var sprite=get_node("../../HUD/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(cnt) + "/Sprite2D")
		game.Chairs[int(name.erase(0,3))-1]=game.Slots[cnt-1]
		sprite.reparent(self)
		sprite.position = Vector2.ZERO
		sprite.scale = Vector2(0.5, 0.5)
		game.Slots[cnt-1]="null"
		print("slots: ",game.Slots)
		print("chairs: ",game.Chairs)
		check_for_completion()
		return
	game.slot_spaces_shake()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func check_for_completion() -> void:
	for i in range(chair_minigame.get_child_count()):
		if game.Chairs[i] != chair_minigame.get_child(i).name.erase(0,1):
			#print("completion chair check: ",chair_minigame.get_child(i).name.erase(0,1))
			return
	print("you got orange key")

func pick_up() -> void:
	var chair_nr=int(name.erase(0,3))
	print("chair nr: ",chair_nr)
	#game.Slots[cnt] == toy_name
	var j:int=0
	for i in game.Slots:
		j+=1
		if i=="null":
			var slot=get_node("../../HUD/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(j))
			var sprite=self.get_child(1)
			game.Slots[j-1]=game.Chairs[chair_nr-1]
			game.Chairs[chair_nr-1]="null"
			sprite.reparent(slot)
			sprite.position = slot.size/2
			sprite.scale = Vector2(1.3, 1.3)
			print("slots: ",game.Slots)
			print("chairs: ",game.Chairs)
			return
	game.slot_spaces_shake()
