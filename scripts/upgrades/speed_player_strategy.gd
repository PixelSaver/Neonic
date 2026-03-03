class_name SpeedPlayerStrategy
extends BasePlayerStrategy

@export var speed_multiplier : float = 1.2

func apply_upgrade(player:Player):
	player.player_speed *= speed_multiplier
