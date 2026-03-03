extends Node

# Game state
enum STATE{
	START,
	SHOP,
	FIGHT,
}
var game_state

var player_ref : Player

var enemies : Array[Enemy]

func register_enemy(enemy:Enemy):
	enemies.append(enemy)
