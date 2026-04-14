extends Polygon2D
class_name SpecialEnding

signal ended

func _ready() -> void:
	$CanvasLayer/Button.pressed.connect(func():
		Global.go_to_state(Global.State.HQ)
		ended.emit()
		await get_tree().process_frame
		self.queue_free()
	)
