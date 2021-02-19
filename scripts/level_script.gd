class_name LevelScript

const NM_CLASS = "Odysseus"
const NM_MECH = "Mech"
const NM_BOSS = "Captain Richardson"
const NM_PILOT = "Pilot"
const NM_RESIST = "CIR-C3"

var level_name

var cockpit_ref
var comms_ref
var manager_ref
var glitch_ref

func _init():
	level_name = "NONE"

func run_dialogue(dialogue: DialogueTree):
	while dialogue.active_node:
		dialogue.active_node = yield(run_node(dialogue.active_node), "completed")

func run_node(dialogue_node: DialogueNode) -> DialogueNode:
	for line in dialogue_node.lines:
		yield(run_line(line), "completed")
	if not dialogue_node.links:
		return null
	for link in dialogue_node.links:
		# little messy; also allows for a response button that can't be used
		if link.auto_complete:
			return link.next_node
		var button = comms_ref.add_response(link.link_text)
		button.link_ref = link
		button.connect("selected", link, "_on_Response_Button_selected")
		link.connect("link_selected", dialogue_node, "complete_node", [link])
	return yield(dialogue_node, "node_completed")

func run_line(dialogue_line: DialogueLine):
	yield(manager_ref.get_tree().create_timer(dialogue_line.wait), "timeout")
	var item_ref = comms_ref.print_message(dialogue_line.speaker, dialogue_line.line)
	dialogue_line.send_line(item_ref)
	if dialogue_line.has_exec:
		while not dialogue_line.completed:
			yield(manager_ref.get_tree().create_timer(0.1), "timeout")

func run_level_script():
	pass

func glitch_message(line_item_ref, time_in):
	var start_time = OS.get_ticks_msec()
	var message_text = line_item_ref.get_node("VBoxContainer/Label") as Label
	glitch_ref.set_rect(message_text.rect_global_position, message_text.rect_size)
	var time_diff = 0.0
	while time_diff < time_in:
		glitch_ref.set_glitch_percentage(time_diff / time_in)
		yield(manager_ref.get_tree(), "idle_frame")
		time_diff = (OS.get_ticks_msec() - start_time) / 1000.0

func unglitch_message(line_item_ref, time_out):
	var start_time = OS.get_ticks_msec()
	# var line_control = line_item_ref as Control
	# glitch_ref.set_rect(line_control.rect_global_position, line_control.rect_size)
	var time_diff = 0.0
	while time_diff < time_out:
		glitch_ref.set_glitch_percentage(1.0 - time_diff / time_out)
		yield(manager_ref.get_tree(), "idle_frame")
		time_diff = (OS.get_ticks_msec() - start_time) / 1000.0
