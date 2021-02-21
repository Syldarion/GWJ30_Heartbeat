extends Node

export(NodePath) var title_glitch_path
export(NodePath) var continue_button_path

onready var title_glitch = get_node(title_glitch_path) as GlitchEffect
onready var continue_button = get_node(continue_button_path)

var time_to_next_glitch
var time_since_last_glitch
var glitch_time = 0.5
var current_glitch_time = 0.0
var is_glitching = false
var half_time

func _ready():
	var player_level = PlayerVariables.get("player_level")
	
	if player_level == null:
		PlayerVariables.set("player_level", "level_01", true)
		player_level = PlayerVariables.get("player_level")
		continue_button.hide()
	
	time_to_next_glitch = rand_range(2.0, 5.0)
	glitch_time = rand_range(0.5, 1.0)
	time_since_last_glitch = 0.0
	half_time = glitch_time / 2.0

func _process(delta):
	if is_glitching:
		current_glitch_time += delta
		run_glitch()
	else:
		time_since_last_glitch += delta
	
	if not is_glitching and time_since_last_glitch > time_to_next_glitch:
		is_glitching = true
	if is_glitching and current_glitch_time > glitch_time:
		is_glitching = false
		time_to_next_glitch = rand_range(2.0, 5.0)
		glitch_time = rand_range(0.5, 1.0)
		time_since_last_glitch = 0.0
		half_time = glitch_time / 2.0
		current_glitch_time = 0.0

func run_glitch():
	if current_glitch_time > half_time:
		# unglitch
		var unglitch_time = current_glitch_time - half_time
		title_glitch.set_glitch_percentage(1.0 - unglitch_time / half_time)
	else:
		# glitch
		title_glitch.set_glitch_percentage(current_glitch_time / half_time)

func _on_NewGameButton_pressed():
	GameManager.load_level("res://scripts/levels/training_level.gd")


func _on_ContinueButton_pressed():
	var player_level = PlayerVariables.get("player_level")
	
	if player_level == null:
		PlayerVariables.set("player_level", "level_01", true)
		player_level = PlayerVariables.get("player_level")
	
	GameManager.load_level("res://scripts/levels/%s.gd" % player_level)
