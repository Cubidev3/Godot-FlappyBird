extends Scenary

onready var area = $Area2D

func _physics_process(delta):
	for body in area.get_overlapping_bodies():
		if body is Bird:
			body._hit_ground()
