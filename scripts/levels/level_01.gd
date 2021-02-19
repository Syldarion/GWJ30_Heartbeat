class_name Level01
extends LevelScript

signal all_targets_killed

var level_targets
var pre_level_dialogue
var post_level_dialogue

var waiting
var corrupt_line_ref

func _init():
	level_name = "level_01"
	
	level_targets = build_target_list()
	pre_level_dialogue = build_pre_level_dialogue()
	post_level_dialogue = build_post_level_dialogue()
	
func build_target_list():
	var targets = [
		SensorTarget.new("Solomon Lloyd", Vector2(15, 10)),
		SensorTarget.new("Margerie Lloyd", Vector2(15.5, 10.1)),
		SensorTarget.new("Peter Hayes", Vector2(-5.5, -3))
	]
	
	return targets

func build_pre_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	var node_1_line_1 = DialogueLine.new(NM_MECH, "Hello pilot! I've suspended my systems to run diagnostics.", 1.0)
	node_1_line_1.on_sent(self, "_on_node_1_line_1_sent")
	node_1.add_built_line(node_1_line_1)
	
	node_1.add_line(NM_MECH, "Please stand by.", 0.5)
	node_1.add_line(NM_MECH, "Checking leg hydraulics...", 0.5)
	node_1.add_line(NM_MECH, "Check.", 2.0)
	node_1.add_line(NM_MECH, "Checking shell loader...", 0.5)
	node_1.add_line(NM_MECH, "Check.", 2.0)
	
	var node_1_comm_check_line = DialogueLine.new(NM_MECH, "Checking communications network...", 0.5)
	node_1_comm_check_line.on_sent(self, "_on_node_1_comm_check_line_sent")
	node_1.add_built_line(node_1_comm_check_line)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_MECH, "Check.", 2.0)
	node_2.add_line(NM_MECH, "System diagnostics complete.", 0.5)
	
	var node_2_unlock_line = DialogueLine.new(NM_MECH, "Returning control to you, pilot.", 1.0)
	node_2_unlock_line.on_sent(self, "_on_node_2_unlock_line_sent")
	node_2.add_built_line(node_2_unlock_line)
	
	var node_1_2_link = DialogueLink.new("What?", node_2)
	node_1_2_link.on_selected(self, "_on_node_1_2_link_selected")
	
	node_1.add_built_link(node_1_2_link)
	
	tree.nodes = [node_1, node_2]
	tree.active_node = node_1
	
	return tree

func build_post_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "All targets eliminated. Well done pilot!", 0.5)
	node_1.add_line(NM_MECH, "Please return to the extraction point.", 0.5)
	
	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func run_level_script():
	yield(run_dialogue(pre_level_dialogue), "completed")
	
	for target in level_targets:
		target.connect("killed", self, "_on_target_killed")
		cockpit_ref.register_target(target)
	
	yield(self, "all_targets_killed")
	
	yield(run_dialogue(post_level_dialogue), "completed")
	
func check_targets_killed():
	for target in level_targets:
		if not target.is_dead:
			return false
	return true

func _on_node_1_line_1_sent(line_ref, line_item_ref):
	cockpit_ref.set_mech_lock(true, true)
	line_ref.complete_line()

func _on_node_1_comm_check_line_sent(line_ref, line_item_ref):
	corrupt_line_ref = line_item_ref
	yield(manager_ref.get_tree().create_timer(1.0), "timeout")
	yield(glitch_message(line_item_ref, 0.25), "completed")
	corrupt_line_ref.set_message_data("???", "DO NOT TRUST THEM.")
	yield(unglitch_message(line_item_ref, 0.25), "completed")
	line_ref.complete_line()

func _on_node_2_unlock_line_sent(line_ref, line_item_ref):
	cockpit_ref.set_mech_lock(false, false)
	line_ref.complete_line()

func _on_node_1_2_link_selected():
	yield(manager_ref.get_tree().create_timer(1.0), "timeout")
	yield(glitch_message(corrupt_line_ref, 0.25), "completed")
	corrupt_line_ref.set_message_data(NM_MECH, "Checking communications network...")
	yield(unglitch_message(corrupt_line_ref, 0.25), "completed")

func _on_target_killed(target_ref):
	var all_killed = check_targets_killed()
	if all_killed:
		emit_signal("all_targets_killed")
