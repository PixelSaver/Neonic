extends EntityData
class_name BodyData

@export_group("Body Data")
@export var max_hp := 10.0
@export var move_speed := 1.0
@export var weight := 1.0
@export var dash := 1.0
#TODO Add skills and ultimates
@export var skill = null
@export var ultimate = null
@export var ultimate_energy_required := 0.0

#TODO Actually give bodies different stats
#BUG Star shape gets caught in the boundaries
