extends Interactable
@onready var line_2d: Line2D = $Line2D
@onready var safe_minigame: CanvasLayer=$"../../SafeMinigame"
@onready var notif:Control=$"../../HUD2/Notfication"
var first_play:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact(_player: Node) -> void:
	safe_minigame.visible=!safe_minigame.visible
	if !first_play:
		first_play=true
		notif.stay_duration+=3
		notif.show_notification("Type in the cypher and move the handle down to verify.")
		notif.stay_duration-=3
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=false
