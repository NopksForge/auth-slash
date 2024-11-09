extends StaticBody3D

#@onready var health_system = $HealthSystem

func _ready():
	# Set collision layers
	collision_layer = 0b00000000_00000000_00000000_00000010  # layer 2 (ground)
	collision_mask = 0b00000000_00000000_00000000_00000010   # layer 2 (ground)

#func take_damage(amount: float) -> void:
	#health_system.take_damage(amount) 
