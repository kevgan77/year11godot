extends Node
var knife_experience = 1
var knife_level = 1
var knife_damage = 5
var knife_speed = 1

func add_xp():
	knife_experience+=1
	if knife_experience > 5:
		knife_experience = 0
		knife_damage +=3
		
