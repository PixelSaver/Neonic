@tool
extends CenterContainer
class_name HomeAnimationHelper


@export var spline_lines: Array[SplineLine] = []
@export var box_lines: Array[BoxLine] = []
@export var special_controls: Array[Control] = []
@export_range(0.0, 1.0) var test_t : float = 0.0 :
	set(v):
		test_t = v
		if Engine.is_editor_hint():
			anim_title(v)
@export var title : RichTextLabel

func anim_title(t:float):
	t = clampf(t, 0.0, 1.0)
	var full_text = "Neonic HQ"
	
	var visible_count = int(round(t * full_text.length()))
	
	var revealed = full_text.substr(0, visible_count)
	
	title.text = "| " + revealed + " |"

func anim_splines(t:float):
	t = clampf(t, 0.0, 1.0)
	for l in spline_lines:
		l.display_proportion = t

func anim_boxes(t:float):
	t = clampf(t, 0.0, 1.0)
	for box in box_lines:
		if t <= 0.5:
			box.outline_proportion = Vector2((t*2.0), 0.0)
		else:
			box.outline_proportion = Vector2(1.0, ((t-0.5)*2.0))
	
	for control in special_controls:
		if t <= 0.5:
			control.scale = Vector2((t*2.0), 0.1)
		else:
			control.scale = Vector2(1.0, ((t-0.5)*2.0))
