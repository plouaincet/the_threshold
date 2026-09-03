extends Interactable
@onready var line_2d: Line2D = $Line2D
@onready var vent_minigame: CanvasLayer = $"../../VentMinigame"
@onready var game: Node2D = $"../.."
@onready var notif:Control=$"../../HUD2/Notfication"
var flg:bool=false
var custom_cursor:bool=false
var first_opening:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.visible=false

func interact(_player: Node) -> void:
	if vent_minigame.visible==true:
		vent_minigame.visible=false
	else:
		if flg==true and vent_minigame.visible==false:
			vent_minigame.visible=true
		else:
			if game.Slots[game.selected_frame]=="Clips" or vent_minigame.finished_cutting:
				if !first_opening:
					first_opening=true
					notif.stay_duration+=3
					notif.show_notification("Use your cursor to reach the GREEN key.")
					notif.stay_duration-=3
				vent_minigame.visible=true
			else:
				game.slot_spaces_shake()
			
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
