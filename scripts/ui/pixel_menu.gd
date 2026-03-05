extends Control
class_name PixelMenu

var is_animating = false

func start_anim():
	pass

func end_anim():
	pass

static func get_all_tweenables(all_parents:Array[Node]) -> Array[Tweenable]:
	var out : Array[Tweenable] = []
	for parent in all_parents:
		for child in parent.get_children():
			var n = child as Control
			if child.get_child_count() == 0: continue
			var tweenable_index = n.get_children().find_custom(
				func(_child) -> bool:
					return _child is Tweenable
			)
			if tweenable_index == -1: continue
			var tweenable = n.get_children()[tweenable_index]
			out.append(tweenable)
	return out
