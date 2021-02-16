class_name Level01
extends LevelScript

var waiting
var corrupt_line_ref

func _init():
	level_name = "level_01"

func build_pre_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	var node_1_line_1 = DialogueLine.new("Mech", "Hello pilot! I've suspended my systems to run diagnostics.")
	node_1_line_1.connect("line_sent", self, "_on_node_1_line_1_sent")
	node_1_line_1.has_exec = true
	node_1.add_built_line(node_1_line_1)
	
	node_1.add_line("Mech", "Please stand by.")
	node_1.add_line("Mech", "Checking leg hydraulics...")
	node_1.add_line("Mech", "Check.")
	node_1.add_line("Mech", "Checking shell loader...")
	node_1.add_line("Mech", "Check.")
	
	var node_1_comm_check_line = DialogueLine.new("Mech", "Checking communications network...")
	node_1_comm_check_line.connect("line_sent", self, "_on_node_1_comm_check_line_sent")
	node_1_comm_check_line.has_exec = true
	node_1.add_built_line(node_1_comm_check_line)
	
	var node_2 = DialogueNode.new()
	node_2.add_line("Mech", "Check.")
	node_2.add_line("Mech", "System diagnostics complete.")
	
	var node_2_unlock_line = DialogueLine.new("Mech", "Returning control to you, pilot.")
	node_2_unlock_line.connect("line_sent", self, "_on_node_2_unlock_line_sent")
	node_2_unlock_line.has_exec = true
	node_2.add_built_line(node_2_unlock_line)
	
	var node_1_2_link = DialogueLink.new("What?", node_2)
	node_1_2_link.connect("link_selected", self, "_on_node_1_2_link_selected")
	
	node_1.add_built_link(node_1_2_link)
	
	tree.nodes = [node_1, node_2]
	tree.active_node = node_1
	
	return tree

func build_post_level_dialogue():
	pass

func run_level_script():
	yield(run_dialogue(pre_level_dialogue), "completed")
	
func run_dialogue(dialogue: DialogueTree):
	while dialogue.active_node:
		dialogue.active_node = yield(run_node(dialogue.active_node), "completed")
	print("DIALOGUE COMPLETE")

func stop_waiting():
	waiting = false

func run_node(dialogue_node: DialogueNode) -> DialogueNode:
	print("RUN NODE")
	for line in dialogue_node.lines:
		yield(run_line(line), "completed")
	print("LINES DONE")
	if not dialogue_node.links:
		return null
	for link in dialogue_node.links:
		var button = comms_ref.add_response(link.link_text)
		button.connect("selected", link, "_on_Response_Button_selected")
		link.connect("link_selected", dialogue_node, "complete_node", [link])
	return yield(dialogue_node, "node_completed")

func run_line(dialogue_line: DialogueLine):
	print("RUN LINE")
	yield(manager_ref.get_tree().create_timer(2.0), "timeout")
	var item_ref = comms_ref.print_message(dialogue_line.speaker, dialogue_line.line)
	dialogue_line.send_line(item_ref)
	if dialogue_line.has_exec:
		while not dialogue_line.completed:
			yield(manager_ref.get_tree().create_timer(0.1), "timeout")

func _on_node_1_line_1_sent(line_ref, line_item_ref):
	cockpit_ref.set_mech_lock(true)
	line_ref.complete_line()

func _on_node_1_comm_check_line_sent(line_ref, line_item_ref):
	corrupt_line_ref = line_item_ref
	yield(manager_ref.get_tree().create_timer(1.0), "timeout")
	corrupt_line_ref.set_message_data("???", "DO NOT TRUST THEM.")
	line_ref.complete_line()

func _on_node_2_unlock_line_sent(line_ref, line_item_ref):
	cockpit_ref.set_mech_lock(false)
	line_ref.complete_line()

func _on_node_1_2_link_selected():
	yield(manager_ref.get_tree().create_timer(1.0), "timeout")
	corrupt_line_ref.set_message_data("Mech", "Checking communications network...")
