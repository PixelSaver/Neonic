extends RigidBody2D
class_name Enemy

@export_group("Exports")
@export var health_component : HealthComponent
@export_category("Tweakables")
@export var damage : float = 1.0
@export var knockback : float = 1.0

func _ready() -> void:
	Global.register_enemy(self)

func _get_attack() -> Attack:
	var atk = Attack.new()
	atk.damage = self.damage
	atk.knockback = self.knockback
	return atk

func _on_body_entered(body: Node) -> void:
	if body is not Player: return 
	var player = body as Player
	player.health_component.damage(_get_attack())
