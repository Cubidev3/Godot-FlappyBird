class_name ScenaryHandler
extends Node

const MOVE_DIR = Vector2.LEFT.x

export var speeds: PoolRealArray = [] as PoolRealArray
var cam: Camera2D = null
var screen_rect = Vector2.ZERO

var stop_updating = false

func _ready():
	get_camera()
	get_screen_rect()
	init_generators()
	
func _physics_process(delta):
	update_scenary(delta)

func get_screen_rect() -> void:
	screen_rect = get_viewport().get_visible_rect().size

func get_camera() -> void:
	for brother in get_parent().get_children():
		if brother is Camera2D:
			cam = brother
			return
			
	cam = null
	
func init_generators() -> void:
	for generator in get_tree().get_nodes_in_group("Generator"):
		generator.start()

func update_scenary(delta: float):
	if stop_updating: return
	
	for scenary in get_children():
		if scenary is Scenary:
			if can_be_destroyed(scenary):
				scenary.queue_free()
				continue
			
			var speed = 0
			if is_valid_id(scenary.id):
				speed = speeds[scenary.id]
				
			move(scenary, speed, delta)
			
func can_be_destroyed(scenary: Scenary) -> bool:
	return (scenary.global_position.x + scenary.extents.x) < (cam.global_position.x - (screen_rect.x / 2))
			
func is_valid_id(id: int) -> bool:
	return id >= 0 and id < speeds.size()
	
func move(scenary: Node2D, speed: float, delta: float) -> void:
	scenary.global_position.x += speed * MOVE_DIR * delta

func _on_Bird_died():
	stop_updating = true
