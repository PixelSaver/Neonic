extends Node

var colors = {
	"blue": Color(0.0, 0.493, 3.294),
	"red": Color(2.844, 0.0, 0.289),
}

enum State {
	START,
	START_OPTIONS,
	WEAPONS,
	SHOP,
	FIGHT,
}
var scenes = {
	State.WEAPONS : preload("res://scenes/ui/start_menu/button_menu.tscn"),
}
var game_state : State = State.START
var is_animating = false
func go_to_state(new_state:State):
	if new_state == game_state: return
	print("Going")
	game_state = new_state
	match new_state:
		State.WEAPONS:
			print("Right one")
			var scene = scenes[State.WEAPONS] as PackedScene
			var inst = scene.instantiate()
			get_tree().root.add_child(inst)

var player_ref : Player :
	set(val):
		player_ref = val
		print("Boom")

var root : Node
var bullet_manager : BulletManager

var enemies : Array[Enemy]

func register_enemy(enemy:Enemy):
	enemies.append(enemy)
