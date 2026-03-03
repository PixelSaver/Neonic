class_name ExpPlayerStrategy
extends BasePlayerStrategy

@export var exp_multiplier : float = 0.1

func apply_upgrade(player:Player):
	player.exp_mult += exp_multiplier
