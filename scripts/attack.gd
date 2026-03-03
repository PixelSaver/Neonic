@tool
extends Resource
class_name Attack

@export var damage := 1.0
## Knockback vector encoding direction and strength of knockback
@export var knockback := Vector2.ZERO

## Set the knockback using the position, normalizes the direction, and then multiplies by the kb_strength
func calc_knockback(attacker:Node2D, attacked:Node2D, kb_strength:float) -> Vector2:
	var dir = attacked.global_position - attacker.global_position
	knockback = dir * kb_strength
	return knockback
