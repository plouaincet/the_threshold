extends Interactable
@onready var line_2d: Line2D = $Line2D
@onready var intro_letter: CanvasLayer = $"../../IntroLetter"
@onready var game: Node2D = $"../.."
var flg:bool=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.visible=false

func interact(_player: Node) -> void:
	intro_letter.visible=!intro_letter.visible
	if intro_letter.visible==false and flg:
		flg=false
		game.get_white_key()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=false
