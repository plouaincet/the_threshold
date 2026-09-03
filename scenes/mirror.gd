extends Interactable
@onready var line_2d: Line2D = $Line2D
var clean_mirror: Texture2D = load("res://sprites/et2_oglinda.png")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var game: Node2D = $"../.."
@onready var clean: Sprite2D = $Clean
@onready var label2: Label = $"../../HUD2/Label"
@onready var ceiling: Node2D = $Clean/Ceiling
@onready var sub_viewport: SubViewport = $SubViewport
@onready var label: Label = $SubViewport/Label
@onready var display_sprite: Sprite2D = $Clean/Ceiling/PIN
@onready var player: Node2D = get_tree().get_first_node_in_group("Player")

@export var max_parallax_offset: float = 2.0
@export var parallax_range: float = 200.0

var parallax = Vector2(0, 0)
var initial_pos
var fade_tween: Tween

func set_mirror_text(new_text: String) -> void:
	label.text = new_text
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	display_sprite.texture = sub_viewport.get_texture()

func _process(_delta: float) -> void:
	ceiling.position = initial_pos - parallax

func _ready() -> void:
	initial_pos = ceiling.position
	clean.modulate.a = 0.0
	line_2d.visible = false
	ceiling.modulate.a = 0.0
	set_mirror_text(game.randomise_pin())

func interact(_player: Node) -> void:
	if game.Slots[game.selected_frame] == "Carpa" and clean.modulate.a == 0.0:
		fade_in_curat()
	else:
		game.slot_spaces_shake()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		line_2d.visible = false

func fade_in_curat() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property(clean, "modulate:a", 1.0, 0.5)
	fade_tween.tween_property(ceiling, "modulate:a", 1.0, 0.5)
	fade_tween.tween_callback(sprite_2d.queue_free)
