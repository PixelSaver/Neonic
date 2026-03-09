extends Node

var colors = {
	"blue": Color(0.0, 0.493, 3.294),
	"red": Color(2.844, 0.0, 0.289),
}

enum State {
	START,
	START_OPTIONS,
	HQ,
	SHOP,
	FIGHT,
}
var scenes = {
	State.START : preload("res://scenes/ui/start_menu.tscn"),
	State.HQ : preload("res://scenes/ui/home_menu/home_menu.tscn"),
	#State.FIGHT : preload("res://scenes/main.tscn")
}
var game_state : State = State.START
var is_animating = false
func go_to_state(new_state:State):
	if new_state == game_state: return
	game_state = new_state
	match new_state:
		State.START:
			var scene = scenes[State.START] as PackedScene
			var inst = scene.instantiate() as PixelMenu
			if inst:
				get_tree().root.add_child(inst)
				inst.hide()
				inst.start_anim()
				inst.show()
		State.HQ:
			var scene = scenes[State.HQ] as PackedScene
			var inst = scene.instantiate() as PixelMenu
			if inst:
				get_tree().root.add_child(inst)
				await get_tree().process_frame
				inst.start_anim()

var player_ref : Player :
	set(val):
		player_ref = val
		print("Boom")

var root : Node
var bullet_manager : BulletManager

var enemies : Array[Enemy]

func register_enemy(enemy:Enemy):
	enemies.append(enemy)
