extends Area2D


# Called when the node enters the scene tree for the first time.
func collected():
	var vanish = preload("res://Scenes/vanish.tscn")
	var new_vanish_object = vanish.instantiate()
	get_tree().current_scene.add_child(new_vanish_object)
	new_vanish_object.global_position = global_position
	

func _on_body_entered(body):
	if body.is_in_group("Player"):
		collected()
		queue_free()
