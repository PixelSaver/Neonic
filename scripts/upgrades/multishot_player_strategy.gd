class_name MultishotPlayerStrategy
extends BasePlayerStrategy

@export var multishot_increase : float = 1.0

func apply_upgrade(player: Player):
	player.gun.multishot = max(player.gun.multishot + multishot_increase, 1)
	player.gun.bullets_per_second /= sqrt(player.gun.multishot)
