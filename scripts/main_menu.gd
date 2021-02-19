extends Node

export(NodePath) var continue_node_path

func _ready():
	var continue_node = get_node(continue_node_path)
	var player_level = PlayerVariables.get("player_level")
	
	var continue_button_theme = Theme.new()
	
	if player_level == null:
		PlayerVariables.set("player_level", "level_01", true)
		player_level = PlayerVariables.get("player_level")
		continue_node.text = "Continue"
		continue_button_theme.set_color("font_color", "Label", Color(1.0, 1.0, 1.0, 0.5))
	else:
		continue_node.text = "Continue: %s" % player_level
		continue_button_theme.set_color("font_color", "Label", Color(1.0, 1.0, 1.0, 1.0))
	
	continue_node.theme = continue_button_theme


func _on_NewGameButton_pressed():
	GameManager.load_level("res://scripts/levels/training_level.gd")
	# GameManager.load_level("res://scripts/levels/level_01.gd")
