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
@export var weapon_data: WeaponData
@export_tool_button("Reload weapon visuals") var action = _update_weapon
var _parent : RigidBody2D
var _cooldown := 0.0

func _ready() -> void:
	_parent = parent if parent else get_parent()
	
	_update_weapon()

func _process(delta: float) -> void:
	if not weapon_data: return
	
	if _cooldown > 0: _cooldown -= delta

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
		line.add_point(point * weapon_data.size)
	line.queue_redraw()
	
	_cooldown = weapon_data.fire_rate

func fire(attack:Attack):
	if not weapon_data: return
	if _cooldown > 0: return
	_cooldown = weapon_data.fire_rate
	
	var pellets := weapon_data.bullets_per_cycle
	var explosiveness := weapon_data.explosiveness

	for i in pellets:
		var smooth_delay : float = float(i) / max(pellets - 1, 1) * weapon_data.fire_rate
		var delay := lerpf(smooth_delay, 0.0, weapon_data.explosiveness)
		_spawn_bullet(delay, attack)

func _spawn_bullet(delay:float, attack:Attack):
	if delay > 0: await get_tree().create_timer(delay).timeout
	
	var inst = BULLET.instantiate() as Bullet
	inst.global_transform = self.global_transform
	
	var dir_offset := randf_range(-weapon_data.spread, weapon_data.spread) * 0.5
	inst.global_rotation += dir_offset
	
	attack.damage *= weapon_data.damage
	inst.attack = attack
	
	inst.speed = weapon_data.bullet_speed
	inst.lifetime = weapon_data.bullet_lifetime
	inst.attack.knockback = weapon_data.bullet_knockback * Vector2.from_angle(inst.global_rotation)
	
	#TODO Add the bullet settings using upgrades
	for upgrade in Global.player_ref.bullet_upgrades:
		upgrade.apply_upgrade(inst)
	Global.bullet_manager.register_bullet(inst)
