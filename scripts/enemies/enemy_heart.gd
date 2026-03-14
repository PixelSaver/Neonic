extends Enemy
class_name HeartEnemy

const BULLET = preload("res://scenes/enemy_bullet.tscn")
@export var weapon_data : WeaponData
@export var gun_attack : Attack
@export var lazer_attack_duration := 1.5
@export var lazer_attack_cooldown := 1.0

enum Phase {
	APPROACH,
	LAZER,
	COMBO,
}
enum Axis{
	X,
	Y,
}
var current_phase := Phase.APPROACH
var _cooldown := 0.0
var _timer := 0.0
var last_lazer_axis : Axis = Axis.Y 

func _ready() -> void:
	super()
	health_component.health_changed.connect(_on_health_changed)

func _on_health_changed(h:float, mh:float) -> void:
	if h < mh*0.33333333:
		current_phase = Phase.COMBO
	elif h < mh*0.666666666666:
		current_phase = Phase.LAZER
	print("Current phase: %s" % current_phase)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		self.current_phase = Phase.APPROACH
	if event.is_action_pressed("2"):
		self.current_phase = Phase.LAZER
	if event.is_action_pressed("3"):
		self.current_phase = Phase.COMBO

func _physics_process(delta: float) -> void:
	match current_phase:
		Phase.APPROACH:
			_process_bullets(delta)
		Phase.LAZER:
			_timer += delta
			if _timer > lazer_attack_cooldown:
				_timer -= lazer_attack_cooldown
				var y_axis = false if last_lazer_axis == Axis.Y else true
				last_lazer_axis = Axis.Y if y_axis else Axis.X
				_lazer_attack(y_axis)
		Phase.COMBO:
			_timer += delta
			if _timer > lazer_attack_cooldown:
				_timer -= lazer_attack_cooldown
				var y_axis = false if last_lazer_axis == Axis.Y else true
				last_lazer_axis = Axis.Y if y_axis else Axis.X
				_lazer_attack(y_axis)
func _process_bullets(delta: float) -> void:
	if _cooldown > 0: _cooldown -= delta
	else:
		_cooldown = weapon_data.fire_rate
		_fire()

func _lazer_attack(y_axis:=false) -> void:
	var atk = Attack.new()
	atk.damage = self.damage
	
	var inst = EnemyDatabase.lazer_attack_scene.duplicate().instantiate()
	get_tree().root.add_child(inst)
	inst.global_position = Global.player_ref.global_position
	inst.rotation = PI/2. if y_axis else 0.0
	var lazer = inst as LazerAttack
	lazer.lazer_hit.connect(func(body:Player):
		body.health_component.damage(atk)
	)
	lazer.tween_attack()
func _fire():
	if not weapon_data:
		return
	
	
	var pellets = weapon_data.bullets_per_cycle if weapon_data else 1
	
	for i in pellets:
		var smooth_delay = float(i) / max(pellets - 1, 1) * weapon_data.fire_rate
		var rot = 2*PI*(float(i)/pellets)
		var delay = lerpf(smooth_delay, 0.0, weapon_data.explosiveness)

		_spawn_bullet(delay, gun_attack, rot)
func _spawn_bullet(delay:float, attack:Attack, rot:float):
	if delay > 0: await get_tree().create_timer(delay).timeout
	
	var inst = BULLET.instantiate() as Bullet
	inst.global_position = self.global_position
	inst.global_rotation = rot
	#inst.look_at(Global.player_ref.global_position)
	
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
