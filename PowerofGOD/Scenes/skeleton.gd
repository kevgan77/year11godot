extends CharacterBody2D

@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D
@onready var progress_bar = $ProgressBar
@onready var attack_area: Area2D = $AttackArea

var direction : Vector2
 
var health = 30:
	set(value):
		health = value
		progress_bar.value = value
		if health <= 0:
			find_child("FiniteStateMachine").change_state("DeathSkeleton")
 
func _process(_delta):
	direction = player.position - position
	if direction.x < 0:
		sprite.flip_h = true
		attack_area.scale.x = -1
	else:
		sprite.flip_h = false
		attack_area.scale.x = 1
		
func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
 
func take_damage(damage = 15):
	health -= damage


func _on_attack_area_skeleton_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage()
