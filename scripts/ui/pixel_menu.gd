extends Control
class_name PixelMenu

var is_animating = false

func start_anim():
	pass

func end_anim():
	pass

static func get_all_tweenables(root: Node) -> Array[Tweenable]:
	var out: Array[Tweenable] = []
	_dfs_collect(root, out)
	return out

static func _dfs_collect(node: Node, out: Array[Tweenable]) -> void:
	for child in node.get_children():
		if child is Tweenable:
			out.append(child)
		
		if child.get_child_count() > 0:
			_dfs_collect(child, out)
