extends CharacterBody2D


@export var speed = 90.0
@export var acceleration : float = 10.0
@export var jump_velocity = -300.0
@export var jumps = 1

@export var bullet_node: PackedScene

enum state {IDLE, RUNNING, JUMP_DOWN, JUMP_UP, HIT, ATTACK}

@export var anim_state = state.IDLE

@onready var animator = $AnimatedSprite2D
#@onready var animation_player = $AnimationPlayer
@onready var start_pos = global_position
@onready var attack_area = $AttackArea
@onready var animation_player = $AnimationTree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func shoot():
	var bullet = bullet_node.instantiate()
	
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child",bullet)

func _input(event):
	if event.is_action("shoot"):
		shoot()

func reset():
	global_position = start_pos
	set_physics_process(true)
	anim_state = state.IDLE
	#animator.position = Vector2(0.-5)


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
			anim_state =  state.JUMP_DOWN


func update_animation(direction):
	if direction > 0:
		animator.flip_h = false
		flip(false)
	elif direction < 0:
		animator.flip_h = true
		flip(true)
	match anim_state:
		state.ATTACK:
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
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x,direction*speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
		
	if Input.is_action_just_pressed("attack"):
		anim_state = state.ATTACK
	update_state()
	update_animation(direction)
	move_and_slide()

func enemy_checker(enemy):
	if enemy.is_in_group("Enemy") and velocity.y > 0:
		enemy.die()
		velocity.y = jump_velocity
	elif enemy.is_in_group("Hit"):
		anim_state = state.HIT
		

func _on_hit_box_area_entered(area):
	enemy_checker(area)


func _on_hit_box_body_entered(body):
	enemy_checker(body)
