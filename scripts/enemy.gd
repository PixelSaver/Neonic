extends RigidBody2D
class_name Enemy

enum Types {
	BUG,
	CENTIPEDE,
	BOSS,
	GUNNER,
}

@export_group("Exports")
@export var health_component : HealthComponent
@export var knockback_component : KnockbackComponent
@export_category("Tweakables")
@export var enemy_type : Types = Types.BUG
@export var speed : float = 100.
@export var damage : float = 1.0
@export var knockback_strength : float = 100.0
@export var knockback_resistance : float = 0.0
func get_knockback_resistance() -> float: return knockback_resistance

func _ready() -> void:
	Global.register_enemy(self)
	health_component.death.connect(_on_death)

func _get_attack(target:Node2D) -> Attack:
	var atk = Attack.new()
	atk.damage = self.damage
	atk.calc_knockback(self, target, knockback_strength)
	return atk

func _physics_process(_delta: float) -> void:
	pass
		

func _on_contact(body: Node) -> void:
	#TODO Apply an attack cooldown so that constant contact still means damage
	if body is not Player: return 
	var player = body as Player
	player.health_component.damage(_get_attack(player))

func _on_death():
	Global.unregister_enemy(self)
	self.queue_free()
