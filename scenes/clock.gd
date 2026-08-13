extends Interactable
@onready var line_2d: Line2D = $Line2D
@onready var clockMinigame: CanvasLayer = $"../../ClockMinigame"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clockMinigame.visible=true
	line_2d.visible=false

func interact(_player: Node) -> void:
	clockMinigame.visible=not clockMinigame.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=false
