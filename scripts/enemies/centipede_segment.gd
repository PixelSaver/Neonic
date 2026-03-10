@tool 
extends Marker2D
class_name CentipedeEnemySegment

@export var parent : RigidBody2D
@export var legs : Array[ProceduralLeg]
@export var tool_line_col : ToolLineCollision

func _ready() -> void:
	for leg in legs:
		leg.parent = parent
	tool_line_col.target = parent
