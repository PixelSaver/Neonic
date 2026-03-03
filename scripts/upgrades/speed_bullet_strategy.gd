class_name SpeedBulletStrategy
extends BaseBulletStrategy

@export var speed_multiplier : float = 1.2

func apply_upgrade(bullet: Bullet):
	bullet.bullet_speed *= speed_multiplier
