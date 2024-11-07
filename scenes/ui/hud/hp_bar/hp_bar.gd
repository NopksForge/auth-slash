extends Control

@onready var armor_bar = $ArmorBar
@onready var health_bar = $HealthBar

func _ready():
	# Get the HealthSystem node
	var health_system = get_node("root/HealthSystem")  # Adjusted path to reach HealthSystem
	if health_system:
		health_system.health_changed.connect(_on_health_changed)
		health_system.armor_changed.connect(_on_armor_changed)
		
		# Initialize bars
		_on_health_changed(health_system.current_health, health_system.max_health)
		_on_armor_changed(health_system.current_armor, health_system.max_armor)

func _on_health_changed(current_health: float, max_health: float) -> void:
	var tween = create_tween()
	tween.tween_property(health_bar, "value", (current_health / max_health) * 100, 0.2)
	
	if current_health < health_bar.value:
		# Flash red when taking damage
		var style = health_bar.get_theme_stylebox("fill")
		var original_color = style.bg_color
		style.bg_color = Color.RED
		await get_tree().create_timer(0.1).timeout
		style.bg_color = original_color

func _on_armor_changed(current_armor: float, max_armor: float) -> void:
	var tween = create_tween()
	tween.tween_property(armor_bar, "value", (current_armor / max_armor) * 100, 0.2)    
	if current_armor < armor_bar.value:
		# Flash when taking armor damage
		var style = armor_bar.get_theme_stylebox("fill")
		var original_color = style.bg_color
		style.bg_color = Color.WHITE
		await get_tree().create_timer(0.1).timeout
		style.bg_color = original_color
