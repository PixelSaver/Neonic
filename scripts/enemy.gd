extends RigidBody2D
class_name Enemy

@export_group("Exports")
@export var health_component : HealthComponent
@export var knockback_component : KnockbackComponent
@export_category("Tweakables")
@export var damage : float = 1.0
@export var knockback_strength : float = 100000.0
@export var knockback_resistance : float = 0.0
func get_knockback_resistance() -> float: return knockback_resistance

func _ready() -> void:
	Global.register_enemy(self)

func _get_attack(target:Node2D) -> Attack:
	var atk = Attack.new()
	atk.damage = self.damage
	atk.calc_knockback(self, target, knockback_strength)
	print("Knockback: %s" % str(atk.knockback))
	return atk

#func _physics_process(_delta: float) -> void:
	#var colliding = get_colliding_bodies()
	#for collider in colliding:
		#_on_contact(collider)
		

func _on_contact(body: Node) -> void:
	if body is not Player: return 
	var player = body as Player
	player.health_component.damage(_get_attack(player))
