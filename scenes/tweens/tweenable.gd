@tool
extends Node
class_name Tweenable

@export var dir : Vector2 = Vector2.ZERO
@export var speed : float = 0
@export_tool_button("Randomize speed") var randomize_action = _randomize_speed
var og_gl_pos : Vector2
var og_pos : Vector2
var par : Control

func _randomize_speed():
	speed = randf_range(0.2, 4.0)

func _ready() -> void:
	par = get_parent() as Control
	await get_tree().process_frame
	og_gl_pos = par.global_position
	og_pos = par.position

func custom_tween(_t:Tween, _dur:float, _is_inverse:bool=false):
	pass

func get_final_global_pos():
	return og_gl_pos + dir.normalized() * speed * 100
func get_final_local_pos():
	return og_pos + dir.normalized() * speed * 100

func get_delta():
	return dir.normalized() * speed * 100
