extends Resource
class_name WeaponData

@export_group("Text")
@export var weapon_name: String = "Gun"
@export var weapon_description: String = "Lorem ipsum dolore"
@export_group("Visual")
@export var points: Array[Vector2]
@export var line_closed := true
@export var line_width := 7.0
@export var line_cap_front : Line2D.LineCapMode = Line2D.LINE_CAP_NONE
@export var line_cap_back : Line2D.LineCapMode = Line2D.LINE_CAP_NONE
@export var line_joint : Line2D.LineJointMode = Line2D.LINE_JOINT_BEVEL
@export var gun_size: Vector2 = Vector2(2,2)
@export var editor_scale := 5.0
@export_group("Gun Stats")
@export var fire_rate := 0.2
@export var damage := 1.0
@export var spread := 0.1
@export var explosiveness := 0.0
@export var bullets_per_cycle := 1
@export var bullet_speed := 1500.0
@export var bullet_lifetime := 3.0
@export var bullet_knockback := 1.0
