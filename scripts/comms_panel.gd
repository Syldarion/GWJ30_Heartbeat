extends Node

class_name CommsPanel

signal tree_completed

export(PackedScene) var comms_message_scene
export(PackedScene) var pilot_response_scene
export(PackedScene) var response_scene

export(NodePath) var comms_parent_path
export(NodePath) var comms_scroll_box_path
export(NodePath) var response_parent_path

export var active_line_count = 10
export var characters_per_second = 10
export var time_between_messages = 2.0

onready var comms_parent = get_node(comms_parent_path)
onready var comms_scroll_box = get_node(comms_scroll_box_path)
onready var comms_scroll_bar = comms_scroll_box.get_v_scrollbar()
onready var response_parent = get_node(response_parent_path)

var active_lines = []
var queued_lines = []
var time_between_characters
var time_since_last_character
var lines_queued = false
var scroll_to_bottom = true


var active_dialogue


func _ready():
	# setup_test_tree()
	# start_active_tree()
	pass

func setup_test_tree():
	# var level_one_data = Level01.new()
	# ctive_dialogue = level_one_data.pre_level_dialogue
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

func get_last_line():
	return comms_parent.get_child(comms_parent.get_child_count() - 1)

func remove_line(line):
	comms_parent.remove_child(line)
	line.queue_free()	

func remove_last_line():
	var last_line = comms_parent.get_child(comms_parent.get_child_count() - 1)
	comms_parent.remove_child(last_line)
	last_line.queue_free()

func add_response(link: DialogueLink):
	var new_response = response_scene.instance()
	response_parent.add_child(new_response)
	new_response.text = link.link_text
	new_response.response_link = link
	new_response.connect("selected", self, "_on_Response_Button_selected")

func print_response(link: DialogueLink):
	var new_response = pilot_response_scene.instance()
	comms_parent.add_child(new_response)
	new_response.set_message_data("Pilot", link.link_text)
	scroll_to_bottom = true

func start_active_tree():
	var active_node = active_dialogue.active_node
	var active_lines = active_node.lines
	var active_links = active_node.links
	
	yield(display_active_node_lines(active_lines), "completed")
	
	if active_links:
		display_dialogue_links(active_links)
	else:
		emit_signal("tree_completed")
	
func display_active_node_lines(lines):
	for line in lines:
		yield(get_tree().create_timer(time_between_messages), "timeout")
		add_line(line.speaker, line.line)

func display_dialogue_links(links):
	for link in links:
		add_response(link)

func _on_Response_Button_selected(link):
	link.select_link()
	print_response(link)
	active_dialogue.active_node = link.next_node
	var children = response_parent.get_children()
	for response in children:
		response_parent.remove_child(response)
		response.queue_free()
	start_active_tree()
