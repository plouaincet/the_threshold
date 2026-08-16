extends Control
@onready var frame1: TextureRect = $InventoryPosition/InventoryBg/MarginContainer/Slots/Slot1/Frame
@onready var frame2: TextureRect = $InventoryPosition/InventoryBg/MarginContainer/Slots/Slot2/Frame
@onready var frame3: TextureRect = $InventoryPosition/InventoryBg/MarginContainer/Slots/Slot3/Frame
@onready var frame4: TextureRect = $InventoryPosition/InventoryBg/MarginContainer/Slots/Slot4/Frame
@onready var frame5: TextureRect = $InventoryPosition/InventoryBg/MarginContainer/Slots/Slot5/Frame
@onready var game: Node2D = $"../.."
var frames: Array[TextureRect] = []

func _ready() -> void:
	frames = [frame1, frame2, frame3, frame4, frame5]
	for frame in frames:
		frame.visible = false

func _unhandled_input(event: InputEvent) -> void:
	for i in range(frames.size()):
		if event.is_action_pressed("slot" + str(i + 1)):
			select_frame(i)
			game.selected_frame=i
			break

func select_frame(index: int) -> void:
	for i in range(frames.size()):
		frames[i].visible = (i == index)

func _process(_delta: float) -> void:
	pass
