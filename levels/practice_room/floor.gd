extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add this to your ground node
	add_to_group("ground")
