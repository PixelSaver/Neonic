extends Node

# Game state
enum STATE{
	START,
	SHOP,
	FIGHT,
}
var game_state

var player_ref : Player :
	set(val):
		player_ref = val
		print("Boom")

var root : Node
var bullet_manager : BulletManager

var enemies : Array[Enemy]

func register_enemy(enemy:Enemy):
	enemies.append(enemy)
