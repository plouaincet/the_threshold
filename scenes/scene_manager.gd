extends Node
var music_position:float=0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartingScreen.connect("game_entered",handle_start_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func handle_start_game():
	var game=preload("res://scenes/game.tscn").instantiate()
	#var loading=preload("res://scenes/loading_screen.tscn").instantiate()
	#add_child(loading)
	#await get_tree().create_timer(1).timeout
	#$LoadingScreen.queue_free()
	add_child(game)
	$StartingScreen.queue_free()

func second_floor() -> void:
	var et2=preload("res://scenes/etajul_2.tscn").instantiate()
	call_deferred("add_child", et2)
	$Game.queue_free()
