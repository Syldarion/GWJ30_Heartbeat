extends Node

class_name CommsPanel

export(PackedScene) var comms_message_scene
export(PackedScene) var pilot_response_scene

export(NodePath) var comms_parent_path
export(NodePath) var comms_scroll_box_path
export var active_line_count = 10
export var characters_per_second = 10

onready var comms_parent = get_node(comms_parent_path)
onready var comms_scroll_box = get_node(comms_scroll_box_path)
onready var comms_scroll_bar = comms_scroll_box.get_v_scrollbar()

var active_lines = []
var queued_lines = []
var time_between_characters
var time_since_last_character
var lines_queued = false
var scroll_to_bottom = true


func _ready():
	pass

func _process(delta):
	# apparently you have to do this because scrolling in add_line is too fast
	# the length of the scroll area isn't updated immediately
	if scroll_to_bottom:
		comms_scroll_box.scroll_vertical = comms_scroll_bar.max_value
		scroll_to_bottom = false

func queue_line(line: String):
	pass

func add_line(sender: String, line: String):
	var new_message = comms_message_scene.instance()
	comms_parent.add_child(new_message)
	new_message.set_message_data(sender, line)
	scroll_to_bottom = true
