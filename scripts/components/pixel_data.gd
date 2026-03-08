## Parent class for WeaponData and BodyData to generalize the display of the weapons and characters
extends Resource
class_name EntityData

@export_group("Text")
@export var entity_name: String = "Gun"
@export var entity_description: String = "Lorem ipsum dolore"
@export_group("Visual")
@export var points: Array[Vector2]
@export var line_closed := true
@export var line_width := 7.0
@export var line_cap_front : Line2D.LineCapMode = Line2D.LINE_CAP_NONE
@export var line_cap_back : Line2D.LineCapMode = Line2D.LINE_CAP_NONE
@export var line_joint : Line2D.LineJointMode = Line2D.LINE_JOINT_BEVEL
@export var gun_size: Vector2 = Vector2(2,2)
@export var editor_scale := 5.0
