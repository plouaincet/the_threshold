extends Interactable
@onready var line_2d: Line2D = $Line2D
@onready var game: Node2D = $"../.."
@onready var fuse1: Sprite2D = $Sprite2D/MarginContainer/HBoxContainer/CenterContainer/Sprite2D
@onready var fuse2: Sprite2D = $Sprite2D/MarginContainer/HBoxContainer/CenterContainer2/Sprite2D
@onready var fuse3: Sprite2D = $Sprite2D/MarginContainer/HBoxContainer/CenterContainer3/Sprite2D
@onready var maner: Sprite2D = $Sprite2D/Maner
@onready var on: Sprite2D = $Sprite2D/ON
var fade_tween:Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on.modulate.a=0.0
func interact(_player: Node) -> void:
	if game.Slots[game.selected_frame].begins_with("Fuse"):
		if !fuse1.visible:
			fuse1.visible=true
		elif !fuse2.visible:
			fuse2.visible=true
		elif !fuse3.visible:
			fuse3.visible=true
		else:
			turn_on()
			return
		game.remove_slot_obj()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible=false
func turn_on() -> void:
	fade_tween=create_tween()
	fade_tween.tween_property(maner,"position:y",-10,0.5)
	fade_tween.tween_property(on,"modulate:a",1,0.5)
	fade_tween.tween_callback(func(): game.light_show()) #YIPEEE
