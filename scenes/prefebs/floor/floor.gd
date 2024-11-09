extends StaticBody3D

func _ready() -> void:
	# Collision layer defines which layer(s) this object belongs to
	# Layer 2 means this floor will be detected by objects checking against layer 2
	collision_layer = 0b00000000_00000000_00000000_00000010  # layer 2
	
	# Collision mask defines which layer(s) this object will detect/collide with
	# Layers 1 & 3 means this floor will detect objects on layers 1 and 3
	collision_mask = 0b00000000_00000000_00000000_00000101   # layers 1 & 3
