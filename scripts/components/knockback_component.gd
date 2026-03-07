extends Node
class_name KnockbackComponent

@export var target : RigidBody2D
var _target : RigidBody2D

func _ready() -> void:
	if target != null:
		_target = target
	elif get_parent() != null and get_parent() is RigidBody2D:
		_target = get_parent()
	else:
		print_tree_pretty()
		push_error("Knockback component couldn't find target.")
		return

func apply_knockback(atk:Attack):
	var kb_res := 0.0
	if _target.has_method("get_knockback_resistance"):
		kb_res = _target.knockback_resistance
	print("Applying knockback: %s" % atk.knockback)
	_target.apply_central_impulse(atk.knockback * (1-kb_res))
