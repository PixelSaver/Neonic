extends Enemy
class_name GunnerEnemy

const BULLET = preload("res://scenes/enemy_bullet.tscn")
@export var eye_pivot : Node2D
@export var weapon_data : WeaponData
@export var pathfinding : GunnerPathfindingComponent
@export var attack : Attack
var _cooldown := 0.0
#var to_player : Vector2 = Vector2.ZERO

func _ready() -> void:
	super()
	self.enemy_type = Types.GUNNER

func _process(delta: float) -> void:
	#to_player = self.global_position - Global.player_ref.global_position
	if not Global.player_ref: return
	#eye_pivot.look_at(Global.player_ref.global_position)
	var angle = eye_pivot.get_angle_to(Global.player_ref.global_position)
	eye_pivot.rotate(angle * 0.15)
	
	
	if _cooldown > 0: _cooldown -= delta
	else:
		_cooldown = weapon_data.fire_rate
		_fire()

func _fire():
	if not weapon_data:
		return
	
	
	var pellets = weapon_data.pellets if "pellets" in weapon_data else 1
	
	for i in pellets:
		var smooth_delay = float(i) / max(pellets - 1, 1) * weapon_data.fire_rate
		
		var delay = lerpf(smooth_delay, 0.0, weapon_data.explosiveness)

		_spawn_bullet(delay, attack)
func _spawn_bullet(delay:float, attack:Attack):
	if delay > 0: await get_tree().create_timer(delay).timeout
	
	var inst = BULLET.instantiate() as Bullet
	var eye_pos = (Vector2.RIGHT * 20.0).rotated(eye_pivot.global_rotation)
	inst.global_position = self.global_position + eye_pos
	inst.look_at(Global.player_ref.global_position)
	
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
