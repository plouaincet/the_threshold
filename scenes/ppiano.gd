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
@onready var slot_1: TextureRect = $"../../../../SlotZone/SlotHContainer/Slot1"
@onready var slot_2: TextureRect = $"../../../../SlotZone/SlotHContainer/Slot2"
@onready var slot_3: TextureRect = $"../../../../SlotZone/SlotHContainer/Slot3"
@onready var slot_4: TextureRect = $"../../../../SlotZone/SlotHContainer/Slot4"
@onready var slot_5: TextureRect = $"../../../../SlotZone/SlotHContainer/Slot5"
@onready var slot_6: TextureRect = $"../../../../SlotZone/SlotHContainer/Slot6"
@onready var slot_7: TextureRect = $"../../../../SlotZone/SlotHContainer/Slot7"
@onready var slot_8: TextureRect = $"../../../../SlotZone/SlotHContainer/Slot8"

var notes: Array[String] = ["SDo", "SRe", "SMi", "SFa", "SSol", "SLa", "SSi", "SDo"]
var slots: Array[TextureRect] = []
var current_slot_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	notes.shuffle()
	print(notes)
	slots = [slot_1, slot_2, slot_3, slot_4, slot_5, slot_6, slot_7, slot_8]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_do_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		do.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		do.self_modulate.a = 0.0
		Sdo.play()
		check_note("SDo")

func _on_re_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		re.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		re.self_modulate.a = 0.0
		Sre.play()
		check_note("SRe")

func _on_mi_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		mi.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		mi.self_modulate.a = 0.0
		Smi.play()
		check_note("SMi")

func _on_fa_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		fa.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		fa.self_modulate.a = 0.0
		Sfa.play()
		check_note("SFa")

func _on_sol_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		sol.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		sol.self_modulate.a = 0.0
		Ssol.play()
		check_note("SSol")

func _on_la_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		la.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		la.self_modulate.a = 0.0
		Sla.play()
		check_note("SLa")

func _on_si_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		si.self_modulate.a = 160.0/255.0
		await get_tree().create_timer(0.1).timeout
		si.self_modulate.a = 0.0
		Ssi.play()
		check_note("SSi")


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

func check_note(note_name: String) -> void:
	if current_slot_index >= notes.size():
		return

	var slot = slots[current_slot_index]

	if note_name == notes[current_slot_index]:
		slot.self_modulate = Color(0, 1, 0, 1) # green
	else:
		slot.self_modulate = Color(1, 0, 0, 1) # red

	current_slot_index += 1

	if current_slot_index >= notes.size():
		await get_tree().create_timer(0.6).timeout
		reset_slots()

func reset_slots() -> void:
	for slot in slots:
		slot.self_modulate = Color(1, 1, 1, 1) # back to default/idle appearance
	current_slot_index = 0
