extends Node2D
class_name Bullet

@export var lifetime : int = 180
@export var speed : int = 800
@export var spread : int = 5
@export var damage : int = 2
@export var dagger : bool = false
var back : bool = false


func _ready():
	rotation_degrees += randf_range(-spread,spread)

func _process(delta):
	if dagger:
		speed -= 5
		position += transform.x * speed * delta
		$Sprite2D.rotation += PI / 10
	else:
		position += transform.x * delta * speed
		lifetime -= 1
		if lifetime < 0:
			
			queue_free()
		


func _on_area_2d_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage)
	queue_free()
