extends Node


export(PackedScene) var target_dot_scene
export(NodePath) var dot_parent_node_path

export var scanner_width = 10.0
export var scanner_height = 10.0
export var scanner_pixel_width = 0.0
export var scanner_pixel_height = 0.0

export var test_target_count = 5
export var test_target_speed = 100

var targets = {}
var target_dots = {}

var test_target_destinations = {}

var rng = RandomNumberGenerator.new()

onready var dot_parent_node = get_node(dot_parent_node_path)

class SensorTarget:
	var target_name: String
	var target_location: Vector2

func _ready():
	rng.randomize()
	test_spawn_targets()

func _process(delta):
	test_move_targets(delta)
	update_target_dots()
	
func update_target_dots():
	for target_name in targets:
		target_dots[target_name].position = convert_target_location(targets[target_name].target_location)

func convert_target_location(location: Vector2) -> Vector2:
	var x = location.x * (scanner_pixel_width / scanner_width)
	var y = location.y * (scanner_pixel_height / scanner_height) - (scanner_pixel_height / 2)
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

func test_spawn_targets():
	for i in range(test_target_count):
		var new_target = SensorTarget.new()
		new_target.target_name = "target_%d" % i
		new_target.target_location = get_random_sensor_position()
		add_target(new_target)
		test_target_destinations[new_target.target_name] = get_random_sensor_position()

func test_move_targets(delta):
	for target_name in targets:
		if test_distance_to_target(targets[target_name]) < delta:
			test_target_destinations[target_name] = get_random_sensor_position()
		var direction = (test_target_destinations[target_name] - targets[target_name].target_location).normalized()
		targets[target_name].target_location += direction * delta * test_target_speed

func test_distance_to_target(target: SensorTarget):
	return target.target_location.distance_to(test_target_destinations[target.target_name])

func get_random_sensor_position():
	return Vector2((rng.randf() - 0.5) * scanner_width, rng.randf() * scanner_height)
