extends Node
var music_position:float=0.0
var leaderboard_name:String=""
var leaderboard_time:int=0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"StartingScreen/AudioStreamPlayer2D"
@onready var gamee:Node2D=null
@onready var etajul2:Node2D=null
@onready var leaderboard:CanvasLayer=$StartingScreen/LeaderBoard
var allow_pause:bool=false
var light_state:bool=true
var first_time_start_game:bool=true
var starting_game_in_progress:bool=false
var rotoscope_active:bool=false
var rotoscope_video_player:VideoStreamPlayer=null
var hints_available:int=3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	$StartingScreen.connect("game_entered",handle_start_game)
	if not ResourceLoader.exists("res://sw_config.gd"):
		push_error("Missing sw_config.gd — copy sw_config.gd.example and fill in your keys.")
		return
	var config = load("res://sw_config.gd").new()
	SilentWolf.configure({
		"api_key": config.API_KEY,
		"game_id": config.GAME_ID,
		"game_version": "1.0",
		"log_level": 0
	})
	#SilentWolf.Scores.wipe_leaderboard()
	leaderboard.refresh_leaderboard()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(leaderboard_time)
	pass
func _input(event: InputEvent) -> void:
	if rotoscope_active and event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		if rotoscope_video_player and rotoscope_video_player.is_playing():
			rotoscope_video_player.stop()

func handle_start_game() -> void:
	if starting_game_in_progress:
		return
	starting_game_in_progress=true
	if first_time_start_game:
		first_time_start_game=false
		await rotoscope()
	var game=preload("res://scenes/game.tscn").instantiate()
	gamee=game
	#var loading=preload("res://scenes/loading_screen.tscn").instantiate()
	#add_child(loading)
	#await get_tree().create_timer(1).timeout
	#$LoadingScreen.queue_free()
	add_child(game)
	$StartingScreen.queue_free()
	allow_pause=true
	starting_game_in_progress=false

func second_floor() -> void:
	var et2=preload("res://scenes/etajul_2.tscn").instantiate()
	etajul2=et2
	call_deferred("add_child", et2)
	$Game.queue_free()

func _on_time_timeout() -> void:
	if gamee:
		leaderboard_time+=1
		gamee._change_time(leaderboard_time)
	elif etajul2:
		leaderboard_time+=1
		etajul2._change_time(leaderboard_time)
func player_to_leaderboard() -> void:
	if leaderboard_name!="":
		SilentWolf.Scores.save_score(leaderboard_name, -leaderboard_time)
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	print("Scores: " + str(sw_result.scores))
	
func return_to_title() -> void:
	if gamee:
		gamee.queue_free()
		gamee = null
	if etajul2:
		etajul2.queue_free()
		etajul2 = null
	leaderboard_time = 0
	var starting_screen = preload("res://scenes/starting_screen.tscn").instantiate()
	add_child(starting_screen)
	starting_screen.connect("game_entered", handle_start_game)

func rotoscopereverse() -> void:
	if etajul2:
		etajul2.call_deferred("queue_free")
		etajul2 = null
	var roto = preload("res://scenes/rotoscope.tscn").instantiate()
	add_child(roto)
	var video_player := roto.get_node("VideoStreamPlayer") as VideoStreamPlayer
	video_player.stream = load("res://assets/rotoscope_reverse.ogv")
	rotoscope_video_player = video_player
	rotoscope_active = true
	video_player.stream_position = 0.0
	video_player.play()
	await _wait_for_video_end(video_player)
	rotoscope_active = false
	rotoscope_video_player = null
	roto.queue_free()
	await roll_credits()
	return_to_title()

func rotoscope() -> void:
	audio_stream_player_2d.stop()
	var roto = preload("res://scenes/rotoscope.tscn").instantiate()
	add_child(roto)
	var video_player := roto.get_node("VideoStreamPlayer") as VideoStreamPlayer
	rotoscope_video_player = video_player
	rotoscope_active = true
	video_player.stream_position = 0.0
	video_player.play()
	await _wait_for_video_end(video_player)
	rotoscope_active = false
	rotoscope_video_player = null
	roto.queue_free()

func _wait_for_video_end(video_player: VideoStreamPlayer) -> void:
	while video_player.is_playing():
		await get_tree().process_frame

func roll_credits() -> void:
	var credits = preload("res://scenes/credits.tscn").instantiate()
	add_child(credits)
	await credits.credits_finished
	credits.queue_free()
