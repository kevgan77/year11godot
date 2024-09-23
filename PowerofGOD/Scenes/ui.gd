extends Control

var keys_collected = 0 
@onready var key_label: Label = $KeysCounterLabel


func update_key_counter():
	key_label.text = "Keys: " + str(keys_collected)
	
