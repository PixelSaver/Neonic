@tool
extends RigidBody2D
class_name Player

const POINTS = [
	Vector2(-1,1),
	Vector2(1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
]

@export_group("Script Exports")
@export var line : Line2D
@export var collision_shape : CollisionPolygon2D
@export var health_component : HealthComponent
@export var knockback_component : KnockbackComponent
@export var gun : Gun
@export var gun_center : Node2D
@export_group("Player Shape")
@export_group("Player Movement")
@export var acceleration : float = 15000
@export_group("Tweakables")
@export var knockback_resistance : float = 0.0
func get_knockback_resistance() -> float: return knockback_resistance
## Extra spacing past the Player Size
@export var gun_spacing : float = 10.0 :
	set(val):
		if gun_spacing == val: return
		gun_spacing = val
		if Engine.is_editor_hint():
			_update_gun_hold_pos()
@export var dash_cooldown := 2.0
@export_category("Body")
@export_tool_button("Update player icon") var action_update = _update_size()
@export var body_data : BodyData
@export var weapon_data : WeaponData : 
	set(v):
		weapon_data = v
		if gun:
			gun.weapon_data = weapon_data
var bullet_upgrades : Array[BaseBulletStrategy] = []
var player_upgrades : Array[BasePlayerStrategy] = []
var _is_dashing := false

func _ready() -> void:
	_update_size()
	if Engine.is_editor_hint(): return
	if PlayerSettings and PlayerSettings.weapon_data:
		self.weapon_data = PlayerSettings.weapon_data
	if PlayerSettings and PlayerSettings.body_data:
		self.body_data = PlayerSettings.body_data
	if health_component == null:
		print("Health Component is null")
	else:
		health_component.death.connect(_on_death)
		health_component.health_changed.connect(_on_health_changed)
	Global.player_ref = self

func _update_size():
	if not is_inside_tree(): return
	#if !Engine.is_editor_hint(): return
	
	# Line
	line.clear_points()
	line.position = Vector2.ZERO
	line.closed = body_data.line_closed
	line.begin_cap_mode = body_data.line_cap_front
	line.end_cap_mode = body_data.line_cap_back
	line.joint_mode = body_data.line_joint 
	line.width = body_data.line_width
	line.queue_redraw()
	
	var points : PackedVector2Array = []
	for point in body_data.points:
		points.append(point * body_data.size)
	line.points = points
	collision_shape.polygon = (points)
	
	_update_gun_hold_pos()

func _process(_delta:float) -> void:
	if Engine.is_editor_hint(): 
		return
	var mouse_global = get_global_mouse_position()
	gun_center.look_at(mouse_global)
	
	if Input.is_action_pressed("shoot"):
		gun.fire(_get_attack())
	if Input.is_action_just_pressed("dash"):
		_dash(Input.get_vector("left", "right", "up", "down"))

func _dash(dir:Vector2) -> void:
	dir = dir.normalized()
	_is_dashing = true
	self.apply_central_impulse(dir * 10000.)

func _get_attack() -> Attack:
	var atk = Attack.new()
	atk.damage = 1.0
	atk.knockback = Vector2.ONE * -1 * 1.0
	return atk

func _update_gun_hold_pos():
	if not body_data: return
	gun.position = Vector2((body_data.size.x+body_data.size.y)/2. + gun_spacing, 0)

func _physics_process(_delta:float):
	if not is_inside_tree(): return
	if Engine.is_editor_hint(): return
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO:
		apply_central_force(input_dir * acceleration)

func _on_death():
	print("DEAD")

func _on_health_changed(_h, _mh):
	#print("Health: " + str(health_component.health))
	pass

func add_upgrade(upgrade:BaseStrategy):
	if upgrade is BaseBulletStrategy:
		bullet_upgrades.append(upgrade)
	elif upgrade is BasePlayerStrategy:
		player_upgrades.append(upgrade)
		upgrade.apply_upgrade(self)
