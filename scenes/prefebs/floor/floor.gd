extends StaticBody3D

func _ready() -> void:
	# Set collision layers only
	collision_layer = 0b00000000_00000000_00000000_00000010  # layer 2
	collision_mask = 0b00000000_00000000_00000000_00000101   # layers 1 & 3
