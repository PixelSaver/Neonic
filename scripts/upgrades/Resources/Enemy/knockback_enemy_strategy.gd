extends BaseEnemyStrategy
class_name KnockbackEnemyStrategy

@export var knockback_mult : float = 1.2

func apply_upgrade(enemy: Enemy):
	enemy.enemy_attack.knockback_str *= knockback_mult
