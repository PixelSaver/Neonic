extends CharacterBody2D
#class_name Player

# Components
@onready var health_component : HealthComponent = $HealthComponent
@onready var sprite: Sprite2D = $Sprite2D
var player_speed = 300
var acceleration = 1500
var force := Vector2.ZERO  # Accumulated forces
# Gun stuff
@onready var gun : Gun = $Gun
#var player_mag_size
#var player_mag_current
var gun_automatic : bool = true
var bullet_upgrades : Array[BaseBulletStrategy] = []
var player_upgrades : Array[BasePlayerStrategy] = []

# Called by other nodes to add a force
func apply_force(f: Vector2) -> void:
	force += f
	
func _ready():
	Global.player = self
	
	await get_tree().process_frame
	for i in range(15):
		var up = Global.upgrade_manager.pick_random(1,true)[0]
		self.add_upgrade(up)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left_click") and gun_automatic:
		gun.fire(
			global_position.direction_to(
				get_global_mouse_position()
			)
		)
	elif Input.is_action_just_pressed("left_click"):
		gun.fire(
			global_position.direction_to(
				get_global_mouse_position()
			)
		)
	elif Input.is_action_just_pressed("u") and OS.is_debug_build():
		var upgrade_array : Array[BaseStrategy] = Global.upgrade_manager.pick_random(3)
		#Global.ui.show_upgrade(test_array)
		Global.in_game_ui.show_upgrade(upgrade_array)
	
	
	var direction := Input.get_vector("left", "right", "up", "down")
	# Apply input as acceleration
	var target_velocity = direction.normalized() * player_speed
	velocity += get_impulse(velocity, target_velocity,acceleration, delta)
	move_and_slide()
	

# Impulse functions from https://github.com/nezvers/Godot-GameTemplate/
## Adds an impulse to velocity, like a kickback
func add_impulse(impulse:Vector2)->void:
	velocity += impulse

## Calculate impulse Vector2 for delta time amount
func get_impulse(current_velocity:Vector2, target_velocity:Vector2, acceleration_impulse:float, delta:float)->Vector2:
	var _direction:Vector2 = target_velocity - current_velocity 
	var _distance:float = _direction.length()
	acceleration_impulse = delta * acceleration_impulse
	var _ratio:float = 0
	if _distance > 0.0:
		_ratio = min(acceleration_impulse / _distance, 1.0)
	return (_direction * _ratio)
	
func kill():
	Global.in_game_ui.death_show()
	pass
	
func add_upgrade(upgrade:BaseStrategy):
	if upgrade is BaseBulletStrategy:
		bullet_upgrades.append(upgrade)
	elif upgrade is BasePlayerStrategy:
		player_upgrades.append(upgrade)
		upgrade.apply_upgrade(self)
