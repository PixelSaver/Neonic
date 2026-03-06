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
@export var weapon_data: WeaponData :
	set(val):
		weapon_data = val
		_update_weapon()
#@export var gun_size : Vector2 = Vector2(2, 2) :
	#set(val):
		#gun_size = val
		#if Engine.is_editor_hint():
			#_update_weapon()
var _parent : RigidBody2D

func _ready() -> void:
	_parent = parent if parent else get_parent()
	
	_update_weapon()

func _update_weapon():
	if not weapon_data:
		return
		
	line.clear_points()
	line.position = Vector2.ZERO
	line.closed = weapon_data.line_closed
	line.begin_cap_mode = weapon_data.line_cap_front
	line.end_cap_mode = weapon_data.line_cap_back
	line.joint_mode = weapon_data.line_joint 
	line.width = weapon_data.line_width
	
	for point in weapon_data.points:
		line.add_point(point * weapon_data.gun_size)
	line.queue_redraw()
	

func fire(spread:float, attack:Attack):
	if not weapon_data: return
	
	var dir_offset := randf_range(-weapon_data.spread, weapon_data.spread) * 0.5
	var inst = BULLET.instantiate() as Bullet
	inst.global_transform = self.global_transform
	inst.global_rotation += dir_offset
	attack.damage *= weapon_data.damage
	inst.attack = attack
	#TODO Add the bullet settings using upgrades
	for upgrade in Global.player_ref.bullet_upgrades:
		upgrade.apply_upgrade(inst)
	Global.bullet_manager.register_bullet(inst)
