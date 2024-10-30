extends CharacterBody3D

const SPEED = 5.0
const DASH_SPEED = 20.0  # Speed during dash.
const DASH_TIME = 0.2  # Dash duration in seconds.
const DASH_COOLDOWN = 0.2  # Cooldown between dashes.

var dash_timer = 0.0  # Tracks dash duration.
var dash_cooldown_timer = 0.0  # Tracks cooldown time.
var is_dashing = false  # True if the player is currently dashing.
var last_facing_direction = Vector3.ZERO  # Stores the last direction the player faced.

# Reference to the model (the visual representation).
@onready var model = $Model  # Adjust this path if needed.

func _physics_process(delta: float) -> void:
	# Add gravity if the player is not on the floor.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle dash input and cooldowns.
	if Input.is_action_just_pressed("move_dash") and dash_cooldown_timer <= 0:
		start_dash()

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			stop_dash()

	dash_cooldown_timer = max(0, dash_cooldown_timer - delta)

	# Get input direction from WASD.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Update the last facing direction if there is movement.
	if direction != Vector3.ZERO:
		last_facing_direction = direction

	# Apply movement or dash logic.
	if is_dashing:
		velocity.x = last_facing_direction.x * DASH_SPEED
		velocity.z = last_facing_direction.z * DASH_SPEED
	elif direction != Vector3.ZERO:
		# Normal movement.
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Decelerate smoothly when no input is given.
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Rotate the model to face the movement direction without affecting the CharacterBody3D.
	if last_facing_direction != Vector3.ZERO:
		rotate_model_to_face_direction(last_facing_direction)

	# Move the player.
	move_and_slide()

func rotate_model_to_face_direction(direction: Vector3) -> void:
	# Calculate the target Y rotation based on the movement direction.
	var target_angle = atan2(direction.x, direction.z)

	# Smoothly interpolate the model's Y rotation to the target angle.
	model.rotation.y = lerp_angle(model.rotation.y, target_angle, 0.1)

func start_dash() -> void:
	if is_on_floor():  # Optional: Restrict dash to the ground.
		is_dashing = true
		dash_timer = DASH_TIME
		dash_cooldown_timer = DASH_COOLDOWN

func stop_dash() -> void:
	is_dashing = false
