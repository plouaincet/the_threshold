extends Node
var music_position:float=0.0
var leaderboard_name:String=""
var leaderboard_time:int=0
@onready var gamee:Node2D=null
@onready var etajul2:Node2D=null
@onready var leaderboard:CanvasLayer=$StartingScreen/LeaderBoard
var allow_pause:bool=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartingScreen.connect("game_entered",handle_start_game)
	if not ResourceLoader.exists("res://sw_config.gd"):
		push_error("Missing sw_config.gd — copy sw_config.gd.example and fill in your keys.")
		return
	var config = load("res://sw_config.gd").new()
	SilentWolf.configure({
		"api_key": config.API_KEY,
		"game_id": config.GAME_ID,
		"game_version": "1.0",
		"log_level": 1
	})
	#SilentWolf.Scores.wipe_leaderboard()
	leaderboard.refresh_leaderboard()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(leaderboard_time)
	pass

func handle_start_game():
	var game=preload("res://scenes/game.tscn").instantiate()
	gamee=game
	#var loading=preload("res://scenes/loading_screen.tscn").instantiate()
	#add_child(loading)
	#await get_tree().create_timer(1).timeout
	#$LoadingScreen.queue_free()
	add_child(game)
	$StartingScreen.queue_free()
	allow_pause=true

func second_floor() -> void:
	var et2=preload("res://scenes/etajul_2.tscn").instantiate()
	etajul2=et2
	call_deferred("add_child", et2)
	$Game.queue_free()

func _on_time_timeout() -> void:
	if gamee:
		print("ok")
		leaderboard_time+=1
		gamee._change_time(leaderboard_time)
	elif etajul2:
		leaderboard_time+=1
		etajul2._change_time(leaderboard_time)

func player_to_leaderboard() -> void:
	if leaderboard_name!="":
		SilentWolf.Scores.save_score(leaderboard_name, leaderboard_time)
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
