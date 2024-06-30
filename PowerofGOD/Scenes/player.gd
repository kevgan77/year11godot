extends CharacterBody2D


@export var speed = 100.0
@export var acceleration : float = 10.0
@export var jump_velocity = -300.0
@export var jumps = 1

enum state {IDLE, RUNNING, JUMP_DOWN, JUMP_UP, HIT, ATTACK}

@export var anim_state = state.IDLE

@onready var animator = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
			animation_player.play("attack")
		state.IDLE:
			animation_player.play("idle")
		state.RUNNING:
			animation_player.play("running")
		state.JUMP_UP:
			animation_player.play("jump_up")
		state.JUMP_DOWN:
			animation_player.play("jump_down")
		state.HIT:
			animation_player.play("hit")

func flip(val):
	if not val:
		$CollisionShape2D.position.x = -1.5
		animator.offset = Vector2(4, -40)
	else:
		$CollisionShape2D.position.x = 1.5
		animator.offset = Vector2(-6, -40)
		
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
