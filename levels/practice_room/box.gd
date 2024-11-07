extends RigidBody3D

signal box_destroyed(box: Node3D)

@export var destruction_delay: float = 0.2

var is_being_destroyed: bool = false

func _ready():
	# Enable contact monitoring for collision detection
	contact_monitor = true
	max_contacts_reported = 1
	
	# Set collision layer and mask
	# layer 1: default layer for box
	# layer 2: ground layer
	collision_layer = 0b00000000_00000000_00000000_00000001  # layer 1
	collision_mask = 0b00000000_00000000_00000000_00000010   # layer 2 (ground)
	
	# Add random rotation when spawned
	angular_velocity = Vector3(
		randf_range(-1, 1),
		randf_range(-1, 1),
		randf_range(-1, 1)
	)

func _physics_process(_delta):
	if is_being_destroyed:
		return
		
	# Check for collision with ground
	var colliding_bodies = get_colliding_bodies()
	if colliding_bodies.size() > 0:
		destroy()

func destroy():
	if is_being_destroyed:
		return
		
	is_being_destroyed = true
	box_destroyed.emit(self)
	
	# Scale down and destroy
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, destruction_delay)
	tween.tween_callback(queue_free)
