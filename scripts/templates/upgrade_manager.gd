extends Node2D
class_name UpgradeManager

var all_positive_upgrades : Array[BaseStrategy] = [
	preload("res://Upgrades/Resources/Positive/damage_bullet.tres"),
	preload("res://Upgrades/Resources/Positive/health_player.tres"),
	preload("res://Upgrades/Resources/Positive/multishot_player.tres"),
	preload("res://Upgrades/Resources/Positive/pierce_bullet.tres"),
	preload("res://Upgrades/Resources/Positive/ricochet_bullet.tres"),
	preload("res://Upgrades/Resources/Positive/size_bullet.tres"),
	preload("res://Upgrades/Resources/Positive/speed_bullet.tres"),
	preload("res://Upgrades/Resources/Positive/speed_player.tres"),
]
var all_negative_upgrades : Array[BaseStrategy] = [
	preload("res://Upgrades/Resources/Negative/damage_bullet.tres"),
	preload("res://Upgrades/Resources/Negative/health_player.tres"),
	preload("res://Upgrades/Resources/Negative/multishot_player.tres"),
	preload("res://Upgrades/Resources/Negative/pierce_bullet.tres"),
	preload("res://Upgrades/Resources/Negative/ricochet_bullet.tres"),
	preload("res://Upgrades/Resources/Negative/size_bullet.tres"),
	preload("res://Upgrades/Resources/Negative/speed_bullet.tres"),
	preload("res://Upgrades/Resources/Negative/speed_player.tres"),
]
var all_enemy_upgrades : Array[BaseEnemyStrategy] = [
	preload("res://Upgrades/Resources/Enemy/damage_enemy.tres"),
	preload("res://Upgrades/Resources/Enemy/health_enemy.tres"),
	preload("res://Upgrades/Resources/Enemy/knockback_enemy.tres"),
	preload("res://Upgrades/Resources/Enemy/speed_enemy.tres"),
]

func load_all_upgrades(path: String) -> Array[BaseStrategy]:
	var upgrades: Array[BaseStrategy] = []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".tres"):
				var res = load(path + "/" + filename)
				if res:
					upgrades.append(res)
			filename = dir.get_next()
	return upgrades
	
func _ready():
	Global.upgrade_manager = self
	print_debug("UpgradeManager ready, platform: ", OS.get_name())
	
	# For web builds, use preloaded resources
	if OS.get_name() == "Web":
		print_debug("Using preloaded upgrades for web build")
		# all_upgrades is already populated from the preload array above
		print_debug("Preloaded upgrades count: ", all_positive_upgrades.size())
	else:
		# Dynamic loading for non-web build
		var dynamically_loaded = load_all_upgrades_fallback("res://Upgrades/Resources/Positive")
		if dynamically_loaded.size() > 0:
			all_positive_upgrades = dynamically_loaded
	
	
	# For web builds, use preloaded resources
	if OS.get_name() == "Web":
		print_debug("Using preloaded upgrades for web build")
		# all_upgrades is already populated from the preload array above
		print_debug("Preloaded upgrades count: ", all_negative_upgrades.size())
	else:
		# Dynamic loading for non-web build
		var dynamically_loaded = load_all_upgrades_fallback("res://Upgrades/Resources/Negative")
		if dynamically_loaded.size() > 0:
			all_negative_upgrades = dynamically_loaded
		

func load_all_upgrades_fallback(path: String) -> Array[BaseStrategy]:
	var upgrades: Array[BaseStrategy] = []
	
	# Only try dynamic loading if not in web export
	if OS.get_name() != "Web":
		var dir := DirAccess.open(path)
		if dir:
			dir.list_dir_begin()
			var filename = dir.get_next()
			while filename != "":
				if filename.ends_with(".tres"):
					var res = load(path + "/" + filename)
					if res:
						upgrades.append(res)
						print_debug("Loaded upgrade: ", filename)
				filename = dir.get_next()
			print_debug("Total upgrades loaded dynamically: ", upgrades.size())
		else:
			print_debug("Failed to open directory: ", path)
	
	return upgrades


func pick_random(iter:int, is_positive:bool=false) -> Array[BaseStrategy]:
	var out :Array[BaseStrategy] = []
	var test_arr : Array[BaseStrategy]
	if is_positive: test_arr = all_positive_upgrades
	else: test_arr = all_negative_upgrades
	
	for i in range(iter):
		var rand_upgrade = test_arr[randi_range(0,test_arr.size()-1)] as BaseStrategy
		while Global.player.num_scythe == 0 and rand_upgrade.upgrade_text.to_lower().contains("scythe"):
			rand_upgrade = test_arr[randi_range(0,test_arr.size()-1)] as BaseStrategy
		
		out.append(
			rand_upgrade
		)
	return out

func pick_random_enemy_upgrade(count:int=1) -> Array[BaseEnemyStrategy]:
	var out : Array[BaseEnemyStrategy] = []
	for i in range(count):
		out.append(
			all_enemy_upgrades[
				randi_range(0,all_enemy_upgrades.size()-1)
			]
		)
	return out

func _on_experience_component_level_up(new_level: int) -> void:
	var upgrade_array : Array[BaseStrategy] = pick_random(3)
	#Global.ui.show_upgrade(test_array)
	Global.in_game_ui.show_upgrade(upgrade_array)
