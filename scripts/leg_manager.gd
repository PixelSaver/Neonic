extends Node2D
class_name LegManager

@export var max_simultaneous_steps := 2
var legs : Array[ProceduralLeg] = []

func _ready() -> void:
	for child in get_children():
		if child is ProceduralLeg:
			legs.append(child)

func _process(_delta: float) -> void:
	var stepping_count = 0
	for leg in legs:
		if leg.is_stepping:
			stepping_count += 1
	if stepping_count < max_simultaneous_steps:
		var furthest_leg : ProceduralLeg = null
		var max_dist = 0.0
		for leg in legs:
			if !leg.is_stepping:
				var dist = leg.get_distance_to_resting()
				if dist > leg.step_distance and dist > max_dist:
					max_dist = dist
					furthest_leg = leg
		if furthest_leg:
			furthest_leg.take_step()
