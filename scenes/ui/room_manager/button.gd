extends Button

func _t() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(false)

func _ready() -> void:
	self.pivot_offset_ratio = Vector2.ONE * 0.5

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			_t().tween_property(self, "scale", Vector2.ONE * 1.1, 0.7)
		NOTIFICATION_MOUSE_EXIT:
			_t().tween_property(self, "scale", Vector2.ONE, 0.7)
