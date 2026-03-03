class_name DamageBulletStrategy
extends BaseBulletStrategy

@export var attack_multiplier : float = 1.2

func apply_upgrade(bullet: Bullet):
	bullet.stored_attack.atk_str *= attack_multiplier
