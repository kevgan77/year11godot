extends CharacterBody2D

class_name Player

@export var speed = 90.0
@export var acceleration : float = 5.0
@export var jump_velocity = -300.0
@export var jumps = 1
@export var max_health: int = 80
@onready var stamina_bar = $Stamina_Bar
@onready var health_bar = $Health_Bar
@export var max_stamina = 100.0
@export var health = 80
var stamina = max_stamina
var current_health: int
@export var stamina_depletion_rate = 20.0
@export var stamina_recovery_rate = 5.0
@export var run_speed_multiplier = 1.5
var dead = false
@export var bullet_node: PackedScene

enum state {IDLE, RUNNING, JUMP_DOWN, JUMP_UP, HIT, ATTACK}

@export var anim_state = state.IDLE

@onready var animator = $AnimatedSprite2D
@onready var start_pos = global_position
@onready var attack_area = $AttackArea
@onready var animation_player = $AnimationTree["parameters/playback"]
@onready var animation = $AnimationPlayer
@onready var player_hit: AudioStreamPlayer2D = $PlayerHit


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_run = true  # Track if the character can run

func _ready():
	current_health = max_health
	health_bar = $Health_Bar
	update_health_bar()

func take_damage(amount: int= 5):
	anim_state = state.HIT
	current_health -= amount
	$PlayerHit.play()
	print("HIT")
	#if current_health <= 0:
		#anim_state = state.death
		#current_health = max_health
	if current_health <= 0:
		animation_player.travel("death")
		#print("Working")
		dead = true
	update_health_bar()
	#sfx_hit_2.play()
	
func heal(amount: int = 5):
	current_health += amount
	if current_health < 15:
		#current_health = 45
		current_health += 1
	if current_health <= 0:
		current_health = 0
		#print("working health")
	update_health_bar()

func update_health_bar():
	health_bar.value = current_health
	%LifeBar.frame = health_bar.value/10

func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)

func _input(event):
	if event.is_action("shoot"):
		shoot()

func reset():
	global_position = start_pos
	set_physics_process(true)
	anim_state = state.IDLE

func update_state():
	if anim_state == state.ATTACK:
		return
	if anim_state == state.HIT:
		return
	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.IDLE
		elif velocity.x != 0:
			anim_state = state.RUNNING
	else:
		if velocity.y < 0:
			anim_state = state.JUMP_UP
		else:
			anim_state = state.JUMP_DOWN

func _on_player_hit(damage: int):
	pass#health -= damage
	#$PlayerHit.play()
	#print("HIT")
	#if health <= 0:
		#print("DIE")

func update_animation(direction):
	if dead:
		return
	if direction > 0:
		animator.flip_h = false
		flip(false)
	elif direction < 0:
		animator.flip_h = true
		flip(true)
	if anim_state != state.ATTACK : animation.speed_scale = 1
	match anim_state:
		state.ATTACK:
			animation.speed_scale = WeaponSword.knife_speed
			animation_player.travel("attack")
		state.IDLE:
			animation_player.travel("idle")
		state.RUNNING:
			animation_player.travel("running")
		state.JUMP_UP:
			animation_player.travel("jump_up")
		state.JUMP_DOWN:
			animation_player.travel("jump_down")
		state.HIT:
			animation_player.travel("hit")
		#state.DEATH:
			#animation_player.travel("death")

func flip(val):
	if not val:
		$CollisionShape2D.position.x = -1.5
		animator.offset = Vector2(4, -40)
		attack_area.scale.x = 1
	else:
		$CollisionShape2D.position.x = 1.5
		animator.offset = Vector2(-6, -40)
		attack_area.scale.x = -1

func _physics_process(delta):
	# Add the gravity.

	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	var is_running = Input.is_action_pressed("run") and can_run
	
	if direction and anim_state != state.HIT:
		var effective_speed = speed
		if is_running and stamina > 0:
			effective_speed *= run_speed_multiplier
			stamina -= stamina_depletion_rate * delta
			
			# If stamina is depleted, stop running
			if stamina <= 0:
				stamina = 0
				can_run = false  # Disable running until stamina is fully restored
		else:
			# Recover stamina if not running
			stamina += stamina_recovery_rate * delta
			
		velocity.x = move_toward(velocity.x, direction * effective_speed, acceleration)
		anim_state = state.RUNNING
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
		if anim_state != state.HIT : anim_state = state.IDLE
		stamina += stamina_recovery_rate * delta
	
	# Clamp stamina to its maximum value
	stamina = clamp(stamina, 0, max_stamina)
	
	# Check if stamina has fully recovered
	if stamina == max_stamina:
		can_run = true
	
	# Update the stamina bar
	stamina_bar.value = stamina
	
	if Input.is_action_just_pressed("attack"):

		anim_state = state.ATTACK
	
	update_state()
	update_animation(direction)
	move_and_slide()

func death_scene():
	pass
	
func enemy_checker(enemy):
	if enemy.is_in_group("Enemy") and velocity.y > 0:
		#enemy.die()
		velocity.y = jump_velocity
	elif enemy.is_in_group("Hit"):
		anim_state = state.HIT
		$Camera2D.start_shake()
		take_damage()

func _on_hit_box_area_entered(area):
	enemy_checker(area)

func _on_hit_box_body_entered(body):
	enemy_checker(body)

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage()

func _on_screen_exited():
	queue_free()


func _on_dark_body_entered(body: Node2D) -> void:
	$Camera2D/CanvasLayer/VignetteFader.play("Fade") # Replace with function body.
	if body.is_in_group("Player"):
		speed = 60
		

func _on_dark_body_exited(body: Node2D) -> void:
	$Camera2D/CanvasLayer/VignetteFader.play_backwards("Fade")
	if body.is_in_group("Player"):
		speed = 90.0
		


func _on_healing_timer_timeout(amount = 1) -> void:
	heal(amount)


func _on_spikes_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		take_damage(30)
		


func _on_next_level_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://Scenes/boss_room_test.tscn")
