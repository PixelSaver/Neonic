class_name RicochetBulletStrategy
extends BaseBulletStrategy

@export var ricochet_increase : float = 1.0

func apply_upgrade(bullet: Bullet):
	bullet.bullet_ricochet += ricochet_increase
