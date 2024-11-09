extends Sprite3D

#@onready var armor_bar = $ArmorBar
#@onready var health_bar = $HealthBar

func _ready():
	# Get the HealthSystem node (going up through HPBarAnchor to Scarecrow)
	#var health_system = get_parent().get_parent().get_node("HealthSystem")
	#if health_system:
		#health_system.health_changed.connect(_on_health_changed)
		#health_system.armor_changed.connect(_on_armor_changed)
		#
		## Initialize bars
		#_on_health_changed(health_system.current_health, health_system.max_health)
		#_on_armor_changed(health_system.current_armor, health_system.max_armor)
		pass

#func _on_health_changed(current_health: float, max_health: float) -> void:
	#pass
#
#func _on_armor_changed(current_armor: float, max_armor: float) -> void:
	#pass
