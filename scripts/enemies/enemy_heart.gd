extends Enemy
class_name HeartEnemy

const BULLET = preload("res://scenes/enemy_bullet.tscn")
@export var weapon_data : WeaponData
@export var gun_attack : Attack
@export var lazer_attack_duration := 1.5

enum Phase {
	APPROACH,
	LAZER,
	COMBO,
}
var current_phase := Phase.APPROACH
var _timer := 0.0

func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)

func _on_health_changed(h:float, mh:float) -> void:
	if h < mh*0.33333333:
		current_phase = Phase.COMBO
	elif h < mh*0.666666666666:
		current_phase = Phase.LAZER

func _physics_process(_delta: float) -> void:
	match current_phase:
		Phase.APPROACH:
			pass
		Phase.LAZER:
			pass
		Phase.COMBO:
			pass

func _lazer_attack(y_axis:=false) -> void:
	var atk = Attack.new()
	atk.damage = self.damage
	
	var inst = EnemyDatabase.lazer_attack_scene.duplicate().instantiate()
	get_tree().root.add_child(inst)
	inst.global_position = self.global_position
	inst.rotation = PI/2. if y_axis else 0.0
	var lazer = inst as LazerAttack
	lazer.lazer_hit.connect(func(body:Player):
		body.health_component.damage(atk)
	)
	lazer.tween_attack()
func _fire():
	if not weapon_data:
		return
	
	
	var pellets = weapon_data.pellets if "pellets" in weapon_data else 1
	
	for i in pellets:
		var smooth_delay = float(i) / max(pellets - 1, 1) * weapon_data.fire_rate
		
		var delay = lerpf(smooth_delay, 0.0, weapon_data.explosiveness)

		_spawn_bullet(delay, gun_attack)
func _spawn_bullet(delay:float, attack:Attack):
	if delay > 0: await get_tree().create_timer(delay).timeout
	
	var inst = BULLET.instantiate() as Bullet
	inst.global_position = self.global_position
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
