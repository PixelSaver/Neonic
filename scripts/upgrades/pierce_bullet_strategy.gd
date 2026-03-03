class_name PierceBulletStrategy
extends BaseBulletStrategy

@export var pierce_increase : float = 1.0

func apply_upgrade(bullet: Bullet):
	bullet.bullet_pierce += pierce_increase
