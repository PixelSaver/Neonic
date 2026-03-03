#class_name DamageBulletStrategy
extends BaseBulletStrategy

@export var attack_increase : float = 5.0

func apply_upgrade(bullet: Bullet):
	bullet.stored_attack.atk_str += attack_increase
