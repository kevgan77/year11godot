extends Camera2D

@export var duration: float = 0.5
@export var intensity: float = 15.0

var original_position: Vector2
var time_elapsed: float = 0.0
var is_shaking: bool = false

func _ready():
	original_position = position

func start_shake():
	is_shaking = true
	time_elapsed = 0.0

func _process(delta: float):
	#if Input.is_action_just_pressed("shake"):
		#start_shake()
	if is_shaking:
		time_elapsed += delta
		if time_elapsed < duration:
			position = original_position + Vector2(
				randf_range(-intensity, intensity),
				randf_range(-intensity, intensity)
			)
		else:
			position = original_position
			is_shaking = false

#extends Camera2D
#
#@export var randomStrength: float = 30.0
#@export var shakeFade: float = 5.0
#var rng = RandomNumberGenerator.new()
#
#
#var shake_strength: float = 0
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
##func apply_shake():
	##shake_strength = randomOffset()
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if Input.is_action_pressed("shake"):
		##apply_shake()
		#var rand = randi_range(2.6,3)
		#zoom = Vector2(rand,rand)
	#else:
		#zoom = Vector2(2.87,2.87)
	##if shake_strength > 0:
		##shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		##
		##offset = randomOffset()
		#
##func randomOffset() -> Vector2:
	##return Vector2(rng.randf_range(-shake_strength,shake_strength), rng.randf_range(-shake_strength,shake_strength))
#
