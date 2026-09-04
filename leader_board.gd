extends CanvasLayer

@onready var name_labels: Array[Label] = [
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player1/Player1Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player2/Player2Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player3/Player3Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player4/Player4Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player5/Player5Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player6/Player6Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player7/Player7Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player8/Player8Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player9/Player9Name,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player10/Player10Name,
]

@onready var time_labels: Array[Label] = [
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player1/Player1Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player2/Player2Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player3/Player3Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player4/Player4Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player5/Player5Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player6/Player6Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player7/Player7Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player8/Player8Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player9/Player9Time,
	$CenterContainer/VBoxContainer/TextureRect/MarginContainer/VBoxContainer/Player10/Player10Time,
]
@onready var line_edit: LineEdit = $CenterContainer/VBoxContainer/LineEdit
@onready var user_place_time: Label = $CenterContainer2/VBoxContainer/UserPlaceTime
@onready var scene_manager: Node = $"../.."
var sw_result: Dictionary
func _ready() -> void:
	pass
func refresh_leaderboard() -> void:
	sw_result = await SilentWolf.Scores.get_scores(10).sw_get_scores_complete
	
func _process(_delta: float) -> void:
	pass

func display_leaderboard() -> void:
	if sw_result:
		var top_scores: Array = sw_result.scores

		for i in range(name_labels.size()):
			if i < top_scores.size():
				var entry = top_scores[i]
				name_labels[i].text = entry.player_name
				time_labels[i].text = format_time(entry.score)
				name_labels[i].get_parent().visible = true
			else:
				name_labels[i].text = ""
				time_labels[i].text = ""
				name_labels[i].get_parent().visible = false

func format_time(score) -> String:
	var t := int(score)
	var minutes := t / 60
	var seconds := t % 60
	return "%02d:%02d" % [minutes, seconds]


func _on_line_edit_text_submitted(new_text: String) -> void:
	scene_manager.leaderboard_name=new_text


func _on_texture_rect_pressed() -> void:
	visible=false


func _on_user_search_text_submitted(new_text: String) -> void:
	if new_text == "":
		return

	var top_score_result: Dictionary = await SilentWolf.Scores.get_top_score_by_player(new_text).sw_top_player_score_complete

	if not top_score_result.has("top_score") or top_score_result.top_score == null:
		user_place_time.text = "No score found"
		return

	var player_score = top_score_result.top_score

	var position_result: Dictionary = await SilentWolf.Scores.get_score_position(player_score.score_id).sw_get_position_complete
	var place: int = position_result.position

	user_place_time.text = "Place " + str(place) + ", " + format_time(player_score.score)
