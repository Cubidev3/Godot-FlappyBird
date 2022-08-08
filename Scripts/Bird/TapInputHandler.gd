extends Node

signal tap

var holding_tap = false

func _ready():
	connect("tap", owner, "_on_tap")

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			holding_tap = true
			emit_signal("tap")
			return
		else:
			holding_tap = false
