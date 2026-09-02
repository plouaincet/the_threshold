extends Interactable
@onready var line_2d: Line2D = $Line2D
@onready var vent_minigame: CanvasLayer = $"../../VentMinigame"
@onready var game: Node2D = $"../.."
var flg:bool=false
var custom_cursor:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.visible=false

func interact(_player: Node) -> void:
	if vent_minigame.visible==true:
		vent_minigame.visible=false
	else:
		if flg==true and vent_minigame.visible==false:
			vent_minigame.visible=true
		elif game.Slots[game.selected_frame]=="Clips":
			vent_minigame.visible=true
	if vent_minigame.visible==false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif custom_cursor:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=false
