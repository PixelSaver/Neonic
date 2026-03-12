extends Bullet



func _on_area_2d_body_entered(body:Node):
	print(body.get_class())
	if body is Player:
		var enemy = body as Player
		enemy.health_component.damage(attack)
	queue_free()
