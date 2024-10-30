extends Node3D

@export var follow_speed: float = 10.0  # Speed at which the camera catches up to the player.
@export var follow_offset: Vector3 = Vector3(0, 10, 10)  # Camera offset from the player.
@export var look_at_offset: Vector3 = Vector3(0, -5, 0)  # Point to focus on slightly above the player.

var player: CharacterBody3D  # Reference to the player.

func _ready() -> void:
	# Find the player in the scene tree. Adjust this if the player is in another location.
	player = get_parent().get_node("Player")

func _process(delta: float) -> void:
	if player:
		# Calculate the target position for the camera with the desired offset.
		var target_position = player.global_transform.origin + follow_offset

		# Smoothly interpolate the CameraRig's position towards the target position.
		global_transform.origin = lerp(global_transform.origin, target_position, follow_speed * delta)

		# Make the camera look at the player, with a slight offset to focus above the player.
		look_at(player.global_transform.origin + look_at_offset)
