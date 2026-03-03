class_name HealthPlayerStrategy
extends BasePlayerStrategy

@export var max_health_change : float = 1.2

func apply_upgrade(player:Player):
	player.health_component.update_max_health(max_health_change)
	#player.apply_scale(Vector2.ONE * max_health_change)
