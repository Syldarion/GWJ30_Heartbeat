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
	var cockpit_node = SceneLoader.current_scene
	var comms_node = SceneLoader.current_scene.find_node("CommsPanel")
	loaded_level.setup_references(cockpit_node, comms_node)
	loaded_level.run_level_script()
