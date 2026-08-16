extends StaticBody2D
@onready var line_2d: Line2D = $Line2D
@onready var game:Node2D = $"../.."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.visible=false

func insert_clank() -> void:
	if game.Slots[game.selected_frame]=="Clank":
		game.Slots[game.selected_frame]="null"
		var slott := get_node("../../HUD/PlayerInventory/InventoryPosition/InventoryBg/MarginContainer/Slots/Slot" + str(game.selected_frame + 1))
		for child in slott.get_children():
			if child is Sprite2D:
				child.queue_free()
		game.get_pink_key()
		return
	game.slot_spaces_shake()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=false
