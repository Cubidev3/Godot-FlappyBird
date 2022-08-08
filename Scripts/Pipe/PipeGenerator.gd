extends ScenaryGenerator

var screen_size = Vector2.ZERO
var rng = RandomNumberGenerator.new()

func _ready():
	set_scenary_handler()
	get_project_resolution()

func get_project_resolution() -> void:
	screen_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

func generate_scenary():
	rng.randomize()
	
	var pipe_duo_position = global_position + Vector2(0, rng.randf_range(48, screen_size.y))
	var pipe_duo = scenary_to_generate.instance()
	
	pipe_duo.global_position = pipe_duo_position
	pipe_duo.id = id
	
	scenary_handler.add_child(pipe_duo)
	last_spawned = pipe_duo
