class_name SizeBulletStrategy
extends BaseBulletStrategy

@export var size_multiplier : float = 1.2

func apply_upgrade(bullet: Bullet):
	bullet.apply_scale(Vector2(size_multiplier,size_multiplier)) 
	bullet.stored_attack.knockback_str *= sqrt(size_multiplier)
