extends Area2D
var health = 1
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction)
	$AnimatedSprite2D.flip_h = direction > 0



func _on_timer_timeout():
	direction *= -1
	
func take_damage():
	$AnimatedSprite2D.animation = "hit"
	await $AnimatedSprite2D.animation_finished
	queue_free()




func _on_area_entered(area):
	if area.is_in_group("Player_Attack"):
		take_damage()
