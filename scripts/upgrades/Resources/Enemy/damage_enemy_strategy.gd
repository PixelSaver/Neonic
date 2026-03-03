class_name DamageEnemyStrategy
extends BaseEnemyStrategy

@export var damage_mult : float = 1.2

func apply_upgrade(enemy: Enemy):
	enemy.enemy_attack.atk_str *= damage_mult
