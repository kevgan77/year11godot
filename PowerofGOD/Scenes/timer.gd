extends Node2D


var time_elapsed = 0  # Track time passed

func _ready():
	pass

func _on_GameTimer_timeout():
	time_elapsed += 1  # Increment the time elapsed every second
	$TimerLabel.text = str(time_elapsed)  # Update UI element if necessary

func _process(delta):
	time_elapsed += delta  # Add delta to track time
	$TimerLabel.text = str(floor(time_elapsed))  # Convert to seconds and display
