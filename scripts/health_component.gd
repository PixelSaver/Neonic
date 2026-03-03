class_name HealthComponent extends Node

signal health_changed(health, max_health)

@export var health : float = 10.0
@export var max_health : float = 10.0

func damage(atk: Attack):
	health -= atk.damage

func heal(delta:float) -> float:
	health += delta
	return health
