class_name HealthComponent extends Node

signal health_changed(health, max_health)
signal death()

@export var health : float = 10.0 :
	set(val):
		if val != health:
			health = val
			health_changed.emit(health, max_health)
@export var max_health : float = 10.0 :
	set(val):
		if val != max_health:
			max_health = val
			health_changed.emit(health, max_health)

func damage(atk: Attack):
	health -= atk.damage
	if health < 0:
		death.emit()

func heal(delta:float) -> float:
	health += delta
	return health
