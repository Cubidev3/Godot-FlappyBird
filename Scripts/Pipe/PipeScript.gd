class_name Pipe
extends Area2D

func _physics_process(delta):
	look_for_player()
	
func look_for_player():
	for i in get_overlapping_bodies():
		if i is Bird:
			i._die()
