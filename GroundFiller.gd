extends Sprite

var screen_size = Vector2.ZERO
var cam: Camera2D = null

var sprite_side = 16

func _ready():
	get_camera()
	get_screen_size()
	fill_screen()

func get_camera():
	for brother in get_parent().get_children():
		if brother is Camera2D:
			if brother.current:
				cam = brother
				return
				
	cam = null

func get_screen_size():
	screen_size = get_viewport().get_visible_rect().size

func fill_screen():
	var start_point = Vector2(cam.global_position.x - screen_size.x / 2, global_position.y)
	var end_point = Vector2(cam.global_position.x + screen_size.x / 2, global_position.y + screen_size.y / 2)
	
	var x_scale = abs(end_point.x - start_point.x) / sprite_side
	var y_scale = abs(end_point.y - start_point.y) / sprite_side
	
	global_position = Vector2(end_point.x + start_point.x, end_point.y + start_point.y) / 2
	scale.x = x_scale
	scale.y = y_scale
