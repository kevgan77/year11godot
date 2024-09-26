extends Area2D

#var key_scene = "res://Scenes/key_1.tscn"
#add_child(key_instance)  

#func collected():
	#var vanish = preload("res://Scenes/vanish.tscn")
	#var new_vanish_object = vanish.instantiate()
	#get_tree().current_scene.add_child(new_vanish_object)
	#new_vanish_object.global_position = global_position
	

#func _on_body_entered(body):
	#if body.is_in_group("Player"):
		#UI.keys_collected += 1
		#UI.update_key_counter()
		#collected()
		#queue_free()
