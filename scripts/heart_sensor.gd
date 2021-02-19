extends Node

class_name HeartSensor

export(PackedScene) var target_dot_scene
export(NodePath) var dot_parent_node_path

export var scanner_width = 10.0
export var scanner_height = 10.0
export var scanner_pixel_width = 0.0
export var scanner_pixel_height = 0.0

var targets = {}
var target_dots = {}

onready var dot_parent_node = get_node(dot_parent_node_path)

func _ready():
	pass

func _process(delta):
	# update_target_dots()
	pass

func update_target(target: SensorTarget, position):
	var converted = convert_target_location(position)
	var half_w = scanner_pixel_width / 2
	
	# 32 is the size of the target dot, oh noooo, magic number
	var outside_y = converted.y > -16 or converted.y < (-scanner_pixel_height + 16)
	var outside_x = converted.x > (half_w - 16) or converted.x < (-half_w + 16)
	
	if outside_y or outside_x:
		target_dots[target.target_name].hide()
	else:
		target_dots[target.target_name].show()
	
	target_dots[target.target_name].position = converted

func update_target_dots():
	for target_name in targets:
		target_dots[target_name].position = convert_target_location(targets[target_name].target_location)

func convert_target_location(location: Vector2) -> Vector2:
	var x = location.x * (scanner_pixel_width / scanner_width)
	var y = location.y * (scanner_pixel_height / scanner_height)
	return Vector2(x, y)
	
func add_target(target: SensorTarget):
	if targets.has(target.target_name):
		return
	targets[target.target_name] = target
	target_dots[target.target_name] = spawn_target_dot()
	
func remove_target(target: SensorTarget):
	if not targets.has(target.target_name):
		return
	targets.erase(target.target_name)
	target_dots[target.target_name].queue_free()
	target_dots.erase(target.target_name)

func spawn_target_dot():
	var new_dot = target_dot_scene.instance()
	dot_parent_node.add_child(new_dot)
	return new_dot
