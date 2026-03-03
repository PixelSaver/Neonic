extends Node
class_name PathfindingComponent

@export var parent : Enemy
var _parent : Enemy
var player : Player

func _ready() -> void:
	if parent != null:
		_parent = parent
	elif get_parent() != null and get_parent() is Enemy:
		_parent = get_parent()
	else:
		print_tree_pretty()
		push_error("Pathfinding component couldn't find parent.")
	#HACK Using process frame ot await player ref
	player = Global.player_ref

func _physics_process(_delta: float) -> void:
	if not player: return
	_parent.apply_central_force(
		(player.global_position - _parent.global_position).normalized() * 
		_parent.speed * 100
	)
