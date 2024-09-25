extends Area2D
var health = 100
var direction = 1
var speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction * delta * speed)
	$AnimatedSprite2D.flip_h = direction > 0



func _on_timer_timeout():
	direction *= -1

func take_damage():
	set_process(false)
	$AnimatedSprite2D.play("hit")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func die():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player_Attack"):
		take_damage()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_Attack"):
		take_damage()
