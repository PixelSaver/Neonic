class_name HealthComponent extends Node

signal health_changed(health, max_health)
signal death()

@export var health : float = 10.0 :
	set(val):
		if val != health:
			health = val
			health_changed.emit(health, max_health)
@export var max_health : float = 10.0 :
	set(val):
		if val != max_health:
			max_health = val
			health_changed.emit(health, max_health)
@export var target : RigidBody2D
var _target : RigidBody2D

func _ready() -> void:
	if target != null:
		_target = target
	elif get_parent() != null and get_parent() is RigidBody2D:
		_target = get_parent()
	else:
		print_tree_pretty()
		push_error("Health component couldn't find target.")

func damage(atk: Attack):
	health -= atk.damage
	if _target.has_node(^"KnockbackComponent"):
		var kb_c = _target.get_node(^"KnockbackComponent")
		kb_c.apply_knockback(atk)
	if health < 0:
		death.emit()

func heal(delta:float) -> float:
	health += delta
	return health
