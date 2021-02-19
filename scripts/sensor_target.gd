class_name SensorTarget
extends Object

signal killed(target_ref)

var target_name: String
var target_location: Vector2
var is_dead: bool

func _init(n: String, l: Vector2):
	target_name = n
	target_location = l
	is_dead = false

func kill():
	is_dead = true
	emit_signal("killed", self)
