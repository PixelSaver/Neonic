extends Sprite2D
#class_name Gun

#@onready var bullet_scene = preload("res://Scenes/bullet.tscn")
@onready var muzzle_flash: Sprite2D = $MuzzleFlash
var spread : float = .5
var recoil_str : float = 600
var multishot : int = 1
var bullets_per_second = 5
var timer = 1000000

var hold_distance : float = 100

func _process(delta: float) -> void:
	timer += delta
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var aim :Vector2= get_parent().global_position.direction_to(
				get_global_mouse_position()
			)
		position = aim * hold_distance
		
		rotation = aim.angle()
		var sign = sign(Vector2.RIGHT.dot(Vector2.from_angle(rotation)))
		if sign < 0:
			flip_v = true
			muzzle_flash.position = Vector2(6.84,-7.16)
		else:
			flip_v = false
			muzzle_flash.position = Vector2(6.84,-15.565)


func fire(dir: Vector2) -> bool:
	if timer < 1/float(bullets_per_second): return false
	timer = 0
	
	muzzle_flash_anim()
	
	# normalize the base direction
	dir = dir.normalized()
	var base_angle = dir.angle()
	
	if multishot <= 1:
		var rand_angle = (dir + Vector2.from_angle(randfn(dir.angle(), spread))).angle()
		#_spawn_bullet(rand_angle)
	else:
		# total spread (in radians)
		var total_spread = spread
		var step = total_spread / float(multishot - 1)
		
		for i in range(multishot):
			# offset angles symmetrical across spread
			var offset = (i - (multishot - 1) / 2.0) * step
			#_spawn_bullet(base_angle + offset)
	
	# apply recoil (use original dir, not offset one)
	var player = get_parent() as Player
	player.add_impulse(-dir * recoil_str)
	
	return true

func muzzle_flash_anim():
	muzzle_flash.modulate = Color.WHITE
	muzzle_flash.rotation_degrees = randfn(150,2)
	muzzle_flash.scale = Vector2.ONE * randfn(1,0.1)
	#muzzle_flash.skew = randfn(0,1)
	muzzle_flash.show()
	
	await create_tween().tween_property(
		muzzle_flash, "modulate", Color(255,255,255,0), 1/float(bullets_per_second)/2
	).set_trans(Tween.TRANS_QUINT).finished
	muzzle_flash.hide()

func _spawn_bullet(angle: float) -> void:
	var curr_bullet : Bullet = bullet_scene.instantiate()
	var direction = Vector2.from_angle(angle).normalized()
	
	
	curr_bullet.init(direction)
	curr_bullet.bullet_speed = 1000
	curr_bullet.bullet_lifetime = 3
	curr_bullet.global_position = muzzle_flash.global_position
	Global.bullet_cont.add_child(curr_bullet)
	
	# apply upgrades
	for strategy in Global.player.bullet_upgrades:
		strategy.apply_upgrade(curr_bullet)
	self.scale = curr_bullet.scale
	self.recoil_str = 70 * curr_bullet.scale.x * max(multishot/2,1)
