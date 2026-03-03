class_name ShootPLayerStrategy
extends BasePlayerStrategy

@export var shoot_speed_mult : float = 1.2

func apply_upgrade(player: Player):
	player.gun.bullets_per_second *= shoot_speed_mult
