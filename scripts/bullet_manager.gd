extends Node2D
class_name BulletManager

var bullets : Array[Bullet] = []

func _ready() -> void:
	Global.bullet_manager = self

func register_bullet(bullet:Bullet) -> void:
	bullets.append(bullet)
	add_child(bullet)

func unregister_bullet(bullet:Bullet) -> void:
	bullets.erase(bullet)
	bullet.queue_free()
