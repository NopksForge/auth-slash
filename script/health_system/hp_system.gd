class_name HealthSystem
extends Node

signal health_changed(current_health: float, max_health: float)
signal armor_changed(current_armor: float, max_armor: float)
signal died

@export_range(0, 1000) var max_health: float = 100.0
@export_range(0, 1000) var max_armor: float = 50.0
@export var invulnerability_time: float = 0.5

var current_health: float
var current_armor: float
var is_invulnerable: bool = false

func _ready():
	current_health = max_health
	current_armor = max_armor

func take_damage(damage: float) -> void:
	if is_invulnerable:
		return
		
	# Damage armor first
	if current_armor > 0:
		var armor_damage = min(current_armor, damage)
		current_armor -= armor_damage
		damage -= armor_damage
		armor_changed.emit(current_armor, max_armor)
	
	# If there's remaining damage, apply to health
	if damage > 0:
		current_health -= damage
		current_health = max(0, current_health)
		health_changed.emit(current_health, max_health)
		
		if current_health <= 0:
			died.emit()
	
	# Add invulnerability
	is_invulnerable = true
	await get_tree().create_timer(invulnerability_time).timeout
	is_invulnerable = false

func heal(amount: float) -> void:
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func repair_armor(amount: float) -> void:
	current_armor = min(current_armor + amount, max_armor)
	armor_changed.emit(current_armor, max_armor)
