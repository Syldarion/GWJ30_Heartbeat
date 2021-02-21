extends Node

# LevelScript
var loaded_level

func _ready():
	pass

func load_level(level_script_path):
	var level_script = load(level_script_path)
	loaded_level = level_script.new()
	SceneLoader.load_scene("res://scenes/CockpitRoot.tscn")
	yield(SceneLoader, "scene_loaded")
	# the cockpit node is the root
	var cockpit_node = SceneLoader.current_scene as Cockpit
	# var comms_node = cockpit_node.get_node("CommsPanel")
	# var glitch_node = cockpit_node.get_node("BackBufferCopy/GlitchCover")
	# var weapons_node = cockpit_node.get_node("WeaponStatusGroup")
	# var satisfaction_node = cockpit_node.get_node("KillSatisfactionGroup")
	loaded_level.cockpit_ref = cockpit_node
	loaded_level.comms_ref = cockpit_node.comms_panel
	loaded_level.manager_ref = self
	loaded_level.glitch_ref = cockpit_node.glitch_cover
	loaded_level.weapons_ref = cockpit_node.weapon_status
	loaded_level.satisfaction_ref = cockpit_node.kill_satisfaction
	loaded_level.sensor_ref = cockpit_node.heartbeat_sensor
	loaded_level.run_level_script()
