class_name ScythespeedPlayerStrategy
extends BasePlayerStrategy

@export var scythe_speed_mult : float = 1.3

func apply_upgrade(player:Player):
	player.scythe_manager.revolve_freq *= scythe_speed_mult
