@tool 
extends Area2D
class_name LazerAttack

signal lazer_hit(body:Player)

@export var warning : Control
@export var line : Line2D
@export var collision_shape : CollisionShape2D
@export var attack_length := 3.0
@export_tool_button("Test attack") var atk_action = tween_attack
var lazer_target : RigidBody2D

func _ready() -> void:
	pass
	#collision_shape.disabled = true
	#monitoring = false

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): 
		self.queue_redraw()

func tween_attack() -> void:
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
	warning.scale.y = 0.0
	warning.position.y = 0.0
	warning.modulate.a = 0.0
	line.display_proportion = 0.0
	line.width = 20.0
	line.modulate.a = 1.0
	t.tween_property(warning, "size:y", 20.0, attack_length * 6./10.)
	t.tween_property(warning, "scale:y", 1., attack_length * 6./10.)
	t.tween_property(warning, "modulate:a", 1.0, attack_length * 6./10.)
	t.chain()
	t.tween_property(line, "display_proportion", 1.0, attack_length * 1./10.)
	t.tween_callback(func(): 
		collision_shape.disabled = false
		monitoring = true
		await get_tree().physics_frame
		var bodies = get_overlapping_bodies()
		for body in bodies:
			_on_body_entered(body)
	)
	t.chain()
	#t.tween_interval(attack_length * 1./10.)
	#t.chain()
	t.tween_property(warning, "scale:y", 0.0, attack_length * 3./10.)
	t.tween_property(line, "width", 0.0, attack_length * 3./10.)
	t.tween_property(line, "modulate:a", 0.0, attack_length * 3./10.)
	
	#t.tween_callback(func(): self.monitoring = false)
	#t.tween_callback(func(): collision_shape.disabled = true)

func anim_attack(t:float) -> void:
	t = clampf(t, 0.0, 1.0)
	


func _on_body_entered(body: Node2D) -> void:
	if body is Player: lazer_hit.emit(body as Player)
