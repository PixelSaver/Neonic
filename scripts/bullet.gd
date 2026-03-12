extends Line2D
class_name Bullet

@export var lifetime : float = 180
@export var speed : float = 1500
@export var attack : Attack = Attack.new()
@export var linear_damping : float = 1.0
@export var dagger : bool = false
var back : bool = false

func _ready() -> void:
	#TODO Add knockback here
	self.attack.knockback = Vector2.from_angle(self.global_rotation).normalized() * 1000.0

func _physics_process(delta: float) -> void:
	position += transform.x * delta * speed
	lifetime -= delta
	if lifetime < 0:
		_on_bullet_lifetime_end()
		queue_free()

func _on_bullet_lifetime_end():
	pass


func _on_area_2d_body_entered(body):
	if body is Enemy:
		var enemy = body as Enemy
		enemy.health_component.damage(attack)
	queue_free()
