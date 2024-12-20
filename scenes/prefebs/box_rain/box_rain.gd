extends Node3D

@export var box_scene: PackedScene  # Reference to the Box scene
@export var SPAWN_AREA_SIZE: Vector2 = Vector2(20, 20)  # Width and Length of spawn area
@export var SPAWN_HEIGHT: float = 15.0  # Height at which boxes spawn
@export var SPAWN_INTERVAL: float = 0.5  # Time between spawns
@export var MAX_BOXES: int = 50  # Maximum number of boxes at once

var spawn_timer: float = 0.0
var boxes: Array = []

func _ready() -> void:
	# Create collision shape for ground detection
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= SPAWN_INTERVAL and boxes.size() < MAX_BOXES:
		spawn_box()
		spawn_timer = 0.0

func spawn_box() -> void:
	if !box_scene:
		push_error("Box scene not set in BoxRain!")
		return
		
	var box = box_scene.instantiate()
	add_child(box)
	boxes.append(box)
	
	# Random position within spawn area
	var random_x = randf_range(-SPAWN_AREA_SIZE.x/2, SPAWN_AREA_SIZE.x/2)
	var random_z = randf_range(-SPAWN_AREA_SIZE.y/2, SPAWN_AREA_SIZE.y/2)
	
	# Set position
	box.global_position = global_position + Vector3(random_x, SPAWN_HEIGHT, random_z)
	
	# Connect to box's destroyed signal
	if !box.is_connected("box_destroyed", _on_box_destroyed):
		box.connect("box_destroyed", _on_box_destroyed)

func _on_box_destroyed(box: Node3D) -> void:
	boxes.erase(box)
