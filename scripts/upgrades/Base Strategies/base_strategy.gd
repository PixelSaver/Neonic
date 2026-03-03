class_name BaseStrategy
extends Resource

@export var texture : Texture2D = preload("res://assets/icon.svg")
@export var upgrade_text : String = "Speed"
@export var upgrade_description : String = ""

## Function applied to each node
func apply_upgrade(node):
	pass
