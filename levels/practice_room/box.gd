extends RigidBody3D

signal box_destroyed(box: Node3D)

@export var floor_detection_time: float = 0.2
@export var destruction_delay: float = 0.2

var time_since_spawn: float = 0.0
var can_check_floor: bool = false
var is_being_destroyed: bool = false

func _ready():
	# Enable contact monitoring for collision detection
	contact_monitor = true
	max_contacts_reported = 1
	
	# Add random rotation when spawned
	angular_velocity = Vector3(
		randf_range(-1, 1),
		randf_range(-1, 1),
		randf_range(-1, 1)
	)

func _physics_process(delta):
	if is_being_destroyed:
		return
		
	time_since_spawn += delta
	
	# Wait a bit before starting floor detection
	if time_since_spawn >= floor_detection_time:
		can_check_floor = true
	
	# Check for floor collision using linear velocity
	if can_check_floor and get_contact_count() > 0:
		# Check if we're mostly stopped
		if linear_velocity.length() < 0.1:
			destroy()

func destroy():
	if is_being_destroyed:
		return
		
	is_being_destroyed = true
	
	# Emit signal before destruction
	box_destroyed.emit(self)
	
	# Scale down and destroy
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, destruction_delay)
	tween.tween_callback(queue_free)
