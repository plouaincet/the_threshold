extends TextureRect
@onready var do: TextureRect = $HBoxContainer/Do
@onready var re: TextureRect = $HBoxContainer/Re
@onready var mi: TextureRect = $HBoxContainer/Mi
@onready var fa: TextureRect = $HBoxContainer/Fa
@onready var sol: TextureRect = $HBoxContainer/Sol
@onready var la: TextureRect = $HBoxContainer/La
@onready var si: TextureRect = $HBoxContainer/Si
@onready var play_button: TextureButton = $"../../ButtonCenter/PlayButton"
@onready var Sdo: AudioStreamPlayer2D = $"../../../../../../../../../../Sounds/Do"
@onready var Sre: AudioStreamPlayer2D = $"../../../../../../../../../../Sounds/Re"
@onready var Smi: AudioStreamPlayer2D = $"../../../../../../../../../../Sounds/Mi"
@onready var Sfa: AudioStreamPlayer2D = $"../../../../../../../../../../Sounds/Fa"
@onready var Ssol: AudioStreamPlayer2D = $"../../../../../../../../../../Sounds/Sol"
@onready var Sla: AudioStreamPlayer2D = $"../../../../../../../../../../Sounds/La"
@onready var Ssi: AudioStreamPlayer2D = $"../../../../../../../../../../Sounds/Si"


var notes: Array[String] = ["SDo", "SRe", "SMi", "SFa", "SSol", "SLa", "SSi", "SDo"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notes.shuffle()
	print(notes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_do_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		do.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		do.self_modulate.a = 0.0
		Sdo.play()

func _on_re_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		re.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		re.self_modulate.a = 0.0
		Sre.play()

func _on_mi_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		mi.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		mi.self_modulate.a = 0.0
		Smi.play()
func _on_fa_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		fa.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		fa.self_modulate.a = 0.0
		Sfa.play()
func _on_sol_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		sol.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		sol.self_modulate.a = 0.0
		Ssol.play()
func _on_la_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		la.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		la.self_modulate.a = 0.0
		Sla.play()

func _on_si_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		si.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		si.self_modulate.a = 0.0
		Ssi.play()


func _on_play_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		play_button.self_modulate=Color(100.0/155.0,100.0/155.0,100.0/155.0)
		play_sequence()
		await get_tree().create_timer(0.3).timeout
		play_button.self_modulate=Color(1,1,1)

func play_sequence() -> void:
	var note_map := {
		"SDo": {"sound": Sdo, "visual": do},
		"SRe": {"sound": Sre, "visual": re},
		"SMi": {"sound": Smi, "visual": mi},
		"SFa": {"sound": Sfa, "visual": fa},
		"SSol": {"sound": Ssol, "visual": sol},
		"SLa": {"sound": Sla, "visual": la},
		"SSi": {"sound": Ssi, "visual": si},
	}
	for i in range(notes.size()):
		var note_name = notes[i]
		var sound: AudioStreamPlayer2D = note_map[note_name]["sound"]
		var visual: TextureRect = note_map[note_name]["visual"]

		visual.self_modulate.a = 160.0/255.0
		sound.play()
		await get_tree().create_timer(0.3).timeout
		visual.self_modulate.a = 0.0

		if i == 3:
			await get_tree().create_timer(0.6).timeout
		elif i < notes.size() - 1:
			await get_tree().create_timer(0.3).timeout
