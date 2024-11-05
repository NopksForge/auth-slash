extends Node3D

@export var follow_speed: float = 5.0  # Reduced for smoother follow
@export var base_offset: Vector3 = Vector3(0, 12, 15)  # Base camera position
@export var look_at_offset: Vector3 = Vector3(0, 0, 0)  # Adjusted to look directly at player
@export var movement_influence: float = 0.3  # How much player movement affects camera
@export var max_movement_offset: float = 2.0  # Maximum distance camera can offset from movement
@export var zoom_influence: float = 0.01  # How much movement affects zoom
@export var max_zoom_offset: float = 2.0  # Maximum zoom change
@export var smoothing: float = 3.0  # General smoothing factor

var player: CharacterBody3D
var camera_velocity: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO
var current_movement_offset: Vector3 = Vector3.ZERO
var current_zoom_offset: float = 0.0
var previous_player_position: Vector3 = Vector3.ZERO

func _ready() -> void:
    player = get_parent().get_node("Player")
    if player:
        previous_player_position = player.global_position
        target_position = player.global_position + base_offset

func _physics_process(delta: float) -> void:
    if !player:
        return
        
    # Calculate player's movement velocity
    var player_velocity = (player.global_position - previous_player_position) / delta
    previous_player_position = player.global_position
    
    # Calculate movement-based camera offset
    var movement_offset = Vector3.ZERO
    if player_velocity.length() > 0.1:
        movement_offset = player_velocity.normalized() * movement_influence
        movement_offset.y = 0  # Keep vertical offset constant
        movement_offset = movement_offset.limit_length(max_movement_offset)
    
    # Smoothly interpolate current movement offset
    current_movement_offset = current_movement_offset.lerp(movement_offset, smoothing * delta)
    
    # Calculate zoom based on movement speed
    var target_zoom_offset = player_velocity.length() * zoom_influence
    target_zoom_offset = clamp(target_zoom_offset, 0, max_zoom_offset)
    current_zoom_offset = lerp(current_zoom_offset, target_zoom_offset, smoothing * delta)
    
    # Calculate final camera offset with zoom
    var final_offset = base_offset + current_movement_offset
    final_offset = final_offset * (1.0 + current_zoom_offset)
    
    # Calculate target position
    target_position = player.global_position + final_offset
    
    # Smooth camera movement
    global_position = global_position.lerp(target_position, follow_speed * delta)
    
    # Look at player with smooth rotation
    var current_rotation = Quaternion(global_transform.basis)
    var target_rotation = Quaternion(global_transform.looking_at(
        player.global_position + look_at_offset, Vector3.UP).basis)
    
    global_transform.basis = Basis(current_rotation.slerp(target_rotation, smoothing * delta))