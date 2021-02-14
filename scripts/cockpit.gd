extends Node

export(NodePath) var heartbeat_sensor_node_path

export var forward_speed = 1.0
export var backward_speed = 1.0
export var turn_speed = 15.0

export var sensor_distance = 10.0
export var viewing_angle = 45.0

onready var heartbeat_sensor = get_node(heartbeat_sensor_node_path) as HeartSensor

var level_position = Vector2(0.0, 0.0)
var rotation = 0.0

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
	if Input.is_action_pressed("turn_left"):
		rotation -= deg2rad(turn_speed) * delta
		print(rotation)
	elif Input.is_action_pressed("turn_right"):
		rotation += deg2rad(turn_speed) * delta
		print(rotation)
	
	for target in active_targets:
		var target_pos_transformed = convert_world_to_local(active_targets[target].target_location)
		var temp_x = target_pos_transformed.x
		var temp_y = target_pos_transformed.y
		
		var rad90 = deg2rad(-90)
		
		var new_x = temp_x * cos(rad90) - temp_y * sin(rad90)
		var new_y = temp_x * sin(rad90) + temp_y * cos(rad90)
		
		var visible = point_in_vision(active_targets[target].target_location)
		
		heartbeat_sensor.update_target(active_targets[target], Vector2(new_x, new_y), visible)

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

func rotate_mech(direction):
	pass

func move_forward():
	pass

func move_backward():
	pass

func convert_world_to_local(point: Vector2) -> Vector2:
	var local_x = (point.x - level_position.x) * cos(rotation) + (point.y - level_position.y) * sin(rotation)
	var local_y = -(point.x - level_position.x) * sin(rotation) + (point.y - level_position.y) * cos(rotation)
	return Vector2(local_x, local_y)

func point_in_vision(point: Vector2) -> bool:
	var local = convert_world_to_local(point)
	var polar = cartesian2polar(local.x, local.y)
	
	return polar.y >= deg2rad(-viewing_angle) and polar.y <= deg2rad(viewing_angle) and polar.x <= sensor_distance
