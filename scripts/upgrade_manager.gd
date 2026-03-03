extends Node
class_name UpgradeManager

@export var upgrades : Array[BaseStrategy] = []

## Pick a number of non-overlapping upgrades
func pick_n_random(n:float) -> Array[BaseStrategy]:
	if upgrades.is_empty(): return []
	var copy = upgrades.duplicate()
	var out : Array[BaseStrategy] = []
	for i in range(n):
		var rand_idx = randi_range(0,upgrades.size()-1)
		out.append(copy[rand_idx])
		copy.remove_at(rand_idx)
	return out
