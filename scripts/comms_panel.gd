class_name CommsPanel
extends Node


export(PackedScene) var comms_message_scene
export(PackedScene) var pilot_response_scene
export(PackedScene) var response_scene

export(NodePath) var comms_parent_path
export(NodePath) var comms_scroll_box_path
export(NodePath) var response_parent_path

onready var comms_parent = get_node(comms_parent_path)
onready var comms_scroll_box = get_node(comms_scroll_box_path)
onready var comms_scroll_bar = comms_scroll_box.get_v_scrollbar()
onready var response_parent = get_node(response_parent_path)

var time_scrolling = 0.0
var time_to_scroll = 0.5
var scroll_to_bottom = true
var last_scroll_to_bottom = true
var start_scroll_pos = 0.0


func _ready():
	pass

func _process(delta):
	# apparently you have to do this because scrolling in add_line is too fast
	# the length of the scroll area isn't updated immediately
	if scroll_to_bottom:
		if time_scrolling > time_to_scroll:
			scroll_to_bottom = false
			comms_scroll_box.scroll_vertical = comms_scroll_bar.max_value
		else:
			comms_scroll_box.scroll_vertical = lerp(start_scroll_pos, comms_scroll_bar.max_value, time_scrolling / time_to_scroll)
		
		time_scrolling += delta

func start_scrolling():
	scroll_to_bottom = true
	time_scrolling = 0.0
	start_scroll_pos = comms_scroll_box.scroll_vertical

func print_message(sender: String, line: String) -> CommsMessage:
	var new_message = comms_message_scene.instance()
	comms_parent.add_child(new_message)
	new_message.set_message_data(sender, line)
	start_scrolling()
	return new_message

func add_response(line: String) -> ResponseButton:
	var new_response = response_scene.instance()
	response_parent.add_child(new_response)
	new_response.text = line
	new_response.connect("selected", self, "_on_Response_Button_selected")
	return new_response

func print_response(sender: String, line: String) -> CommsMessage:
	var new_response = pilot_response_scene.instance()
	comms_parent.add_child(new_response)
	new_response.set_message_data(sender, line)
	start_scrolling()
	return new_response
	
func clear_responses():
	var children = response_parent.get_children()
	for response in children:
		response_parent.remove_child(response)
		response.queue_free()

func remove_line(line):
	comms_parent.remove_child(line)
	line.queue_free()
	start_scrolling()

func _on_Response_Button_selected(button):
	if not button.link_ref.skip_print:
		print_response("Pilot", button.link_ref.link_text)
	clear_responses()
