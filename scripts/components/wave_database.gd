extends Node

var waves : Array[WaveData] = [
	preload("res://assets/resources/waves/r1.tres"),
	#preload("res://assets/resources/waves/r1_w2.tres"),
	#preload("res://assets/resources/waves/r1_w3.tres"),
	
]
var _curr_prog := 0
func get_next_wave() -> WaveData: 
	print("PROGRESS: prog %s " % _curr_prog)
	if _curr_prog >= waves.size(): 
		return null
	_curr_prog += 1
	return waves[_curr_prog - 1]
