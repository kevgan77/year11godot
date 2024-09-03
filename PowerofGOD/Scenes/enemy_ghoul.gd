extends Area2D
var max_health = 50
var health = 50
var direction = 1
var speed = 20
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction * delta * speed)
	$AnimatedSprite2D.flip_h = direction > 0

func _health():
	health = max_health
	#if health <= 50:
		#take_damage()

func _on_timer_timeout():
	direction *= -1
	
func take_damage(amount: int = 5):
	if health <= max_health:
		take_damage()
	#if health = amount:
	#$AnimatedSprite2D.animation = "hit"
	await $AnimatedSprite2D.animation_finished
	queue_free()

func die():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("Player_Attack"):
		take_damage(5)
