@tool
extends Node2D
class_name Gun

#TODO Add pooling to bullets
const POINTS = [
	Vector2(1,0),
	Vector2(0,-.5),
	Vector2(0,.5),
]
const BULLET = preload("res://scenes/bullet.tscn")

@export_group("Exports")
@export var parent : RigidBody2D
@export var line : Line2D
@export_group("Customization")
@export var gun_size : Vector2 = Vector2(2, 2) :
	set(val):
		gun_size = val
		if Engine.is_editor_hint():
			_update_size()
var _parent : RigidBody2D

func _ready() -> void:
	if parent != null:
		_parent = parent
	elif get_parent() != null and get_parent() is RigidBody2D:
		_parent = get_parent()
	else:
		print_tree_pretty()
		push_error("Gun couldn't find parent.")
	
	_update_size()

func _update_size():
	if not is_inside_tree(): return
	if !Engine.is_editor_hint(): return
	
	# Line
	line.position = Vector2.ZERO
	line.closed = true
	line.clear_points()
	for point in POINTS:
		line.add_point(point * gun_size)
	line.queue_redraw()

func fire(spread:float, attack:Attack):
	var dir_offset := randf_range(-spread, spread) * 0.5
	var inst = BULLET.instantiate() as Bullet
	inst.global_transform = self.global_transform
	inst.global_rotation += dir_offset
	#TODO Add the bullet settings using upgrades
	for upgrade in Global.player_ref.bullet_upgrades:
		upgrade.apply_upgrade(inst)
	Global.bullet_manager.register_bullet(inst)
