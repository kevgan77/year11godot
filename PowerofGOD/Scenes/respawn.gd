extends Node2D

@export var respawnpoint = false

var activated = false

#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body.get_parent() is Player:
		#pass
		


func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.get_parent() is Player && !activated:
	pass
