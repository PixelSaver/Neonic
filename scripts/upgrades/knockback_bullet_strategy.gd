class_name KnockbackBulletStrategy
extends BaseBulletStrategy

@export var knockback_mult : float = 1.2

func apply_upgrade(bullet: Bullet):
	bullet.stored_attack.knockback_str *= knockback_mult
