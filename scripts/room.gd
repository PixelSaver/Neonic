@tool
extends Node2D
class_name Room

signal room_cleared
signal room_left

@export_group("Script Exports")
@export var enemy_container : Node2D
@export var collision_shape : CollisionPolygon2D
@export var border : Line2D : 
	set(val):
		border = val
@export var room_exit : RoomExit
@export_group("Editor helpers")
@export_tool_button("Save enemies as new wave") var action_save_wave = _save_children_as_wave
@export_tool_button("Spawn all enemies") var action_spawn_all = _spawn_all_enemies
@export_group("Room Variables")
@export_tool_button("Reload collision") var action_reload = _update_col
@export var points : PackedVector2Array :
	set(v):
		points = v
		_update_col()
@export var room_size : Vector2 = Vector2.ZERO :
	set(v):
		room_size = v
		_update_col()
@export var wall_thickness := 50.0
@export var wave_data : WaveData
var is_last_wave := false

func _ready() -> void:
	_update_col()
	if Engine.is_editor_hint(): return
	#self.room_cleared.connect(_on_cleared)
	room_exit.room_exited.connect(func():
		room_left.emit()
		print("Leaving room")
	)

func _update_col():
	if not is_inside_tree(): return
	if border == null or collision_shape == null: return
	#print("Changeing")
	border.closed = true
	border.clear_points()
	var _border_points : PackedVector2Array = []
	for point in points:
		_border_points.append(point * room_size)
	border.points = _border_points
	var poly = border.points
	var offset = Geometry2D.offset_polygon(poly, wall_thickness)
	if offset.size() > 0:
		collision_shape.polygon = offset[0]
	if offset.size() > 1:
		collision_shape.polygon.append_array(offset[1])
	_border_points.reverse()
	_border_points.append(_border_points[0])
	_border_points.append(collision_shape.polygon[collision_shape.polygon.size()-1])
	#_border_points.append(_border_points[_border_points.size()-1])
	collision_shape.polygon = collision_shape.polygon + _border_points
	collision_shape.build_mode = CollisionPolygon2D.BUILD_SOLIDS
	collision_shape.queue_redraw()
	border.queue_redraw()

func _save_children_as_wave():
	if not Engine.is_editor_hint(): return
	
	if wave_data == null:
		push_warning("No WaveData assigned.")
	
	var next_wave := 0
	for spawn in wave_data.enemies:
		next_wave = max(next_wave, spawn.wave + 1)
	
	for child in enemy_container.get_children():
		var enemy = child as Enemy
		if enemy == null: continue
		
		var spawn = EnemySpawn.new()
		spawn.wave = next_wave
		spawn.position = enemy.position
		spawn.enemy_type = enemy.enemy_type
		
		wave_data.enemies.append(spawn)
	print("Saved wave", next_wave, " with ", enemy_container.get_child_count(), " enemies.")
func _spawn_all_enemies():
	if wave_data == null:
		push_warning("No WaveData assigned.")
		return

	for spawn in wave_data.enemies:
		var scene = EnemyDatabase.get_enemy_scene(spawn.enemy_type)
		if scene == null:
			continue

		var inst = scene.instantiate()
		inst.position = spawn.position
		enemy_container.add_child(inst)
		inst.owner = enemy_container
	self.queue_redraw()

func clear_enemies():
	for child in enemy_container.get_children():
		var e = child as Enemy
		if e:
			Global.unregister_enemy(e)
			e.queue_free()

func _group_waves() -> Dictionary:
	var waves := {}
	
	for spawn in wave_data.enemies:
		if not waves.has(spawn.wave):
			waves[spawn.wave] = []
		waves[spawn.wave].append(spawn)
	return waves

func start_waves():
	print("Starting new wave set!")
	if wave_data == null:
		push_warning("No wave data!")
		return
		
	await _run_all_waves()
	if is_last_wave:
		#await Global.all_enemies_cleared
		room_exit.activated = true
	else:
		room_cleared.emit()

func _run_all_waves():
	var waves = _group_waves()
	var indices = waves.keys()
	indices.sort()

	for wave_idx in indices:
		await _run_single_wave(wave_idx, waves[wave_idx])
		

func _run_single_wave(wave_idx:int, spawns:Array):
	var delay := -1.0
	if wave_idx < wave_data.wave_delays.size():
		delay = wave_data.wave_delays[wave_idx]
		
	if delay >= 0:
		await get_tree().create_timer(delay).timeout
	else:
		await Global.all_enemies_cleared
	print("Wave %s starting now" % wave_idx)
	_spawn_enemies_in_wave.call_deferred(spawns)

func _spawn_enemies_in_wave(spawns:Array):
	for spawn in spawns:
		var inst = EnemyDatabase.get_enemy_scene(spawn.enemy_type).instantiate()
		inst.position = spawn.position
		enemy_container.add_child(inst)
