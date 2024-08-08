extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_play_boss_pressed():
	get_tree().change_scene_to_file("res://Scenes/boss_room_test.tscn")
func _on_exit_pressed():
	get_tree().quit()
