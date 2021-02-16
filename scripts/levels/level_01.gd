class_name Level01
extends LevelScript

var corrupt_line_ref

func _init():
	level_name = "level_01"

func build_pre_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	var node_1_line_1 = DialogueLine.new("Mech", "Hello pilot! I've suspended my systems to run diagnostics.")
	node_1_line_1.connect("line_sent", self, "_on_node_1_line_1_sent")
	node_1.add_built_line(node_1_line_1)
	
	node_1.add_line("Mech", "Please stand by.")
	node_1.add_line("Mech", "Checking leg hydraulics...")
	node_1.add_line("Mech", "Check.")
	node_1.add_line("Mech", "Checking shell loader...")
	node_1.add_line("Mech", "Check.")
	
	var node_1_comm_check_line = DialogueLine.new("Mech", "Checking communications network...")
	node_1_comm_check_line.connect("line_sent", self, "_on_node_1_comm_check_line_sent")
	node_1.add_built_line(node_1_comm_check_line)
	
	var node_2 = DialogueNode.new()
	node_2.add_line("Mech", "Check.")
	node_2.add_line("Mech", "System diagnostics complete.")
	
	var node_2_unlock_line = DialogueLine.new("Mech", "Returning control to you, pilot.")
	node_2_unlock_line.connect("line_sent", self, "_on_node_2_unlock_line_sent")
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
	comms_ref.active_dialogue = pre_level_dialogue
	comms_ref.start_active_tree()
	yield(comms_ref, "tree_completed")

func _on_node_1_line_1_sent(line_item_ref):
	cockpit_ref.set_mech_lock(true)

func _on_node_1_comm_check_line_sent(line_item_ref):
	corrupt_line_ref = line_item_ref

func _on_node_2_unlock_line_sent(line_item_ref):
	cockpit_ref.set_mech_lock(false)

func _on_node_1_2_link_selected():
	var last_line = comms_ref.get_last_line()
	yield(last_line.get_tree().create_timer(1.0), "timeout")
	comms_ref.remove_line(last_line)
