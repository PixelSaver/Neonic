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

var _pending_atks : Array[Attack] = []
var _processing := false

func _ready() -> void:
	if target != null:
		_target = target
	elif get_parent() != null and get_parent() is RigidBody2D:
		_target = get_parent()
	else:
		print_tree_pretty()
		push_error("Health component couldn't find target.")

func damage(atk: Attack):
	_pending_atks.append(atk)
	if not _processing:
		_processing = true
		call_deferred("_process_pending_damage")

func _process_pending_damage() -> void:
	var tot_damage := 0.0
	
	for atk in _pending_atks:
		tot_damage += atk.damage
		if _target.has_node(^"KnockbackComponent"):
			var kb_c = _target.get_node(^"KnockbackComponent") as KnockbackComponent
			kb_c.apply_knockback(atk)
	_pending_atks.clear()
	_processing = false
	health -= tot_damage
	if health <= 0 or is_equal_approx(health, 0.0):
		death.emit()

func heal(delta:float) -> float:
	health += delta
	return health
