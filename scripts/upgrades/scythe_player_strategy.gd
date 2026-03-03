class_name ScythePlayerStrategy
extends BasePlayerStrategy

@export var scythe_increment : int = 1

func apply_upgrade(player:Player):
	player.num_scythe = max(0, player.num_scythe + scythe_increment)
