extends Node2D

var time_elapsed = 0
@onready var game_timer: Node2D = $"."
@onready var timer_label: Label = $TimerLabel

func _on_timer_timeout() -> void:
	time_elapsed += 1
	$TimerLabel.text = str(time_elapsed)

func _ready() -> void:
	#$GameTimer.start()
	pass

func _process(delta):
	time_elapsed += delta 
	$TimerLabel.text = str(snapped(time_elapsed,0.01) )
