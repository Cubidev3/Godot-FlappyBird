class_name ScenaryGenerator
extends Node2D

export var scenary_path = ""
onready var scenary_to_generate = load(scenary_path)
export var id = 0

var scenary_handler: ScenaryHandler = null
var last_spawned: Scenary = null

export var distance_between_scenary = 0
export var populate_screen = false

export var scenary_extents = Vector2.ZERO

var started = false

func start():
	scenary_to_generate = load(scenary_path)
	set_scenary_handler()
	set_generator_position()
	
	if populate_screen:
		fill_screen()
		
	started = true
	
func _process(delta):
	if not started: return
	
	if can_generate_another_scenary():
		generate_scenary()

func set_scenary_handler() -> void:
	for brother in get_parent().get_children():
		if brother is ScenaryHandler:
			scenary_handler = brother
			return
			
	scenary_handler = null

func generate_scenary() -> void:
	var pos_to_spawn = self.global_position
	if last_spawned != null:
		pos_to_spawn = position_at_right_side_of(last_spawned)
	
	generate_scenary_at(pos_to_spawn)
	
func generate_scenary_at(pos: Vector2) -> void:
	var scenary: Scenary = scenary_to_generate.instance()
	scenary.id = id
	
	scenary.global_position = pos
	
	scenary_handler.add_child(scenary)
	last_spawned = scenary
	
func position_at_right_side_of(s: Scenary) -> Vector2:
	return s.global_position + Vector2(2 * s.extents.x + distance_between_scenary, 0)
	
func position_at_left_side_of(s: Scenary) -> Vector2:
	return s.global_position - Vector2(2 * s.extents.x + distance_between_scenary, 0)
	
func can_generate_another_scenary() -> bool:
	return last_spawned == null or (global_position.x - last_spawned.global_position.x - 2 * last_spawned.extents.x >= distance_between_scenary)
	
func fill_screen() -> void:
	generate_scenary_at(self.global_position)
	var at_spawn = last_spawned
	
	while (!scenary_handler.can_be_destroyed(last_spawned)):
		generate_scenary_at(position_at_left_side_of(last_spawned))
		
	last_spawned = at_spawn

func set_generator_position() -> void:
	global_position.x = scenary_handler.cam.global_position.x + (scenary_handler.screen_rect.x / 2) + scenary_extents.x
