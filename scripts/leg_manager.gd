@tool
extends Node2D
class_name LegManager

@export var health_component : HealthComponent
var taken_damage := false
@export var max_simultaneous_steps := 2
@export var step_interval := 0.1
var legs : Array[ProceduralLeg] = []
var step_timer := 0.0

func _ready() -> void:
	for child in get_children():
		if child is ProceduralLeg:
			legs.append(child)
	if Engine.is_editor_hint(): return
	if health_component:
		health_component.health_changed.connect(_on_health_changed)

func _on_health_changed(_h, _mh) -> void:
	taken_damage = true

func _process(delta: float) -> void:
	step_timer -= delta
	if step_timer > 0: return
	
	var moving_legs = legs.filter(func(l): return l.is_stepping)
	var steps = max_simultaneous_steps
	if taken_damage: 
		taken_damage = false
		steps = 10
	
	if moving_legs.size() < steps:
		var candidate = _get_best_step_candidate()
		if candidate:
			candidate.take_step()
			step_timer = step_interval

func _get_best_step_candidate() -> ProceduralLeg:
	var best_leg : ProceduralLeg = null
	var max_score = 0.0
	
	for leg in legs:
		if leg.is_stepping: continue
	
		# if any linked leg is moving
		if _is_neighbor_stepping(leg): continue
		
		var dist = leg.get_distance_to_resting()
		if dist > leg.step_distance:
			if dist > max_score:
				max_score = dist
				best_leg = leg
	return best_leg

func _is_neighbor_stepping(leg:ProceduralLeg) -> bool:
	if leg:
		for neighbor in leg.neighbors:
			if neighbor.is_stepping:
				return true
	return false
