extends Control


func _on_play_pressed():
	SoundPlayer.change_music_track("Envi")
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


#func _on_play_boss_pressed():
	#get_tree().change_scene_to_file("res://Scenes/boss_room_test.tscn")

func _on_exit_pressed():
	get_tree().quit()


func _on_tutorial_pressed() -> void:
	SoundPlayer.change_music_track("SSS")
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
