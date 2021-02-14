extends Node

export(NodePath) var heartbeat_sensor_node_path
export(NodePath) var camera_node_path
export(NodePath) var heading_label_path
export(NodePath) var location_label_path

export var forward_speed = 1.0
export var backward_speed = 1.0
export var turn_speed = 15.0

export var sensor_distance = 10.0
export var viewing_angle = 45.0

onready var heartbeat_sensor = get_node(heartbeat_sensor_node_path) as HeartSensor
onready var impulse_camera = get_node(camera_node_path) as ImpulseCamera
onready var heading_label = get_node(heading_label_path) as Label
onready var location_label = get_node(location_label_path) as Label

var level_position = Vector2(0.0, 0.0)
var rotation = 0.0

var last_step_impulse = 0.0
var seconds_between_step_impulse = 0.5

# Ready to fire = ammo_loaded true, shell_empty false, loader_retracted false
# after firing, shell_empty = true
# then the pilot retracts the loader, removes the empty shell
# loads a new shell, and pushes the loader back into place
var ammo_loaded = false
var shell_empty = false
var loader_retracted = true

var active_targets = {}
var locked_target: SensorTarget

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(5):
		var new_target = SensorTarget.new()
		new_target.target_name = "target_%d" % i
		var rand_dist = rng.randf_range(1.0, sensor_distance - 1.0)
		var rand_ang = deg2rad(rng.randf() * 360.0)
		
		new_target.target_location = polar2cartesian(rand_dist, rand_ang)
		active_targets[new_target.target_name] = new_target
	
	for target in active_targets:
		heartbeat_sensor.add_target(active_targets[target])

func _process(delta):
	last_step_impulse += delta
	
	if Input.is_action_pressed("turn_left"):
		rotate_mech(-1, delta)
	elif Input.is_action_pressed("turn_right"):
		rotate_mech(1, delta)
	elif Input.is_action_pressed("move_forward"):
		move_forward(delta)
	elif Input.is_action_pressed("move_backward"):
		move_backward(delta)
	
	for target in active_targets:
		var target_pos_transformed = convert_world_to_local(active_targets[target].target_location)
		var temp_x = target_pos_transformed.x
		var temp_y = target_pos_transformed.y
		
		var rad90 = deg2rad(-90)
		
		var new_x = temp_x * cos(rad90) - temp_y * sin(rad90)
		var new_y = temp_x * sin(rad90) + temp_y * cos(rad90)
		
		heartbeat_sensor.update_target(active_targets[target], Vector2(new_x, new_y))
	
	heading_label.text = "%dDEG" % fmod(rad2deg(rotation), 360.0)
	location_label.text = "[%5.1f,%5.1f]" % [level_position.x, level_position.y]

func load_shell():
	if ammo_loaded or !loader_retracted:
		return

	ammo_loaded = true
	shell_empty = false
	
func unload_shell():
	if !ammo_loaded or !loader_retracted:
		return
	
	ammo_loaded = false
	
func fire_shell():
	if !ammo_loaded or shell_empty or loader_retracted:
		return
	
	shell_empty = true

func retract_loader():
	if loader_retracted:
		return
	
	loader_retracted = true

func extend_loader():
	if !loader_retracted:
		return
	
	loader_retracted = false

func rotate_mech(direction, delta):
	if last_step_impulse > seconds_between_step_impulse:
		impulse_camera.add_impulse(rand_range(0.3, 0.5))
		last_step_impulse = 0.0
	rotation += deg2rad(turn_speed) * delta * direction

func move_forward(delta):
	if last_step_impulse > seconds_between_step_impulse:
		impulse_camera.add_impulse(rand_range(0.3, 0.5))
		last_step_impulse = 0.0
	level_position += polar2cartesian(forward_speed * delta, rotation)

func move_backward(delta):
	if last_step_impulse > seconds_between_step_impulse:
		impulse_camera.add_impulse(rand_range(0.3, 0.5))
		last_step_impulse = 0.0
	level_position -= polar2cartesian(backward_speed * delta, rotation)

func convert_world_to_local(point: Vector2) -> Vector2:
	var local_x = (point.x - level_position.x) * cos(rotation) + (point.y - level_position.y) * sin(rotation)
	var local_y = -(point.x - level_position.x) * sin(rotation) + (point.y - level_position.y) * cos(rotation)
	return Vector2(local_x, local_y)

func point_in_vision(point: Vector2) -> bool:
	var local = convert_world_to_local(point)
	var polar = cartesian2polar(local.x, local.y)
	
	return polar.y >= deg2rad(-viewing_angle) and polar.y <= deg2rad(viewing_angle) and polar.x <= sensor_distance
