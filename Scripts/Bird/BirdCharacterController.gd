class_name Bird
extends KinematicBody2D

# Direction constants
const UP_DIR = Vector2.UP.y
const DOWN_DIR = Vector2.DOWN.y

# Physics
var velocity = 0

# Input
onready var tap_input_handler = $TapInputHandler

# Flap Variables
export var flap_heigth = 25
export var time_to_top_heigth = 0.22
export var time_to_ground = 0.20
export var max_fall_speed = 400

var flap_force = 0
var up_gravity = 0
var fall_gravity = 0

# Bird rotation
onready var sprite = $Sprite
export var start_flap_rotation = -75
export var end_flap_rotation = 75

# Player State
signal died
var died = false
var hit_the_ground = false

func _ready():
	set_variables()
	
func _physics_process(delta):
	if hit_the_ground: return
	
	apply_gravity(delta)
	limit_fall_speed()
	rotate_bird_sprite()
	move()
	
func set_variables():
	flap_force = (2 * flap_heigth) / time_to_top_heigth
	up_gravity = (2 * flap_heigth) / (time_to_top_heigth * time_to_top_heigth)
	fall_gravity = (2 * flap_heigth) / (time_to_ground * time_to_ground)
	
func flap():
	velocity = flap_force * UP_DIR
	sprite.rotation = deg2rad(start_flap_rotation)
	
func move():
	move_and_slide(Vector2(0, velocity), Vector2.UP)
	
func apply_gravity(delta: float) -> void:
	var to_apply = up_gravity * delta * DOWN_DIR
	
	if sign(velocity) == DOWN_DIR or not tap_input_handler.holding_tap:
		to_apply = fall_gravity * delta * DOWN_DIR
		
	velocity += to_apply

func limit_fall_speed():
	if velocity > max_fall_speed:
		velocity = max_fall_speed
		
func _on_tap():
	if died:
		return
		
	flap()
	
func _die():
	died = true
	if velocity < 0: velocity = 0
	emit_signal("died")
	
func _hit_ground():
	_die()
	hit_the_ground = true
	get_tree().reload_current_scene()
	
func rotate_bird_sprite() -> void:
	sprite.rotation = deg2rad(calculate_bird_rotation())
	
func calculate_bird_rotation() -> float:
	var a = (start_flap_rotation - end_flap_rotation) / (-(flap_force) - max_fall_speed)
	var b = end_flap_rotation - (a * max_fall_speed)
	return a * velocity + b
