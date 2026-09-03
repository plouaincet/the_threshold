extends Control

@onready var center_container: CenterContainer = $CenterContainer
@onready var label: Label = $CenterContainer/ColorRect/MarginContainer/Label
@onready var timer: Timer = $Timer


@export var hidden_y: float = -175.0
@export var shown_y: float = 0.0
@export var drop_duration: float = 0.5
@export var stay_duration: float = 2.0

@export var anticipation_offset: float = 20.0
@export var anticipation_duration: float = 0.35
@export var retract_duration: float = 0.15

var allow_notification:bool=true

func _ready() -> void:
	center_container.position.y = hidden_y

func show_notification(text:String) -> void:
	if allow_notification:
		timer.start(stay_duration+1)
		allow_notification=false
		label.text=text
		var tween := create_tween()

		# Drop down with a bounce built into the easing itself
		tween.tween_property(center_container, "position:y", shown_y, drop_duration)\
			.set_trans(Tween.TRANS_BOUNCE)\
			.set_ease(Tween.EASE_OUT)

		# Hold in place so it's readable
		tween.tween_interval(stay_duration)

		# Anticipation: dip down slightly before exiting
		tween.tween_property(center_container, "position:y", shown_y + anticipation_offset, anticipation_duration)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)

		# Then shoot back up and off-screen
		tween.tween_property(center_container, "position:y", hidden_y, retract_duration)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN)

func _on_timer_timeout() -> void:
	allow_notification=true
