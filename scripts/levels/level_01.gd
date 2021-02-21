class_name Level01
extends LevelScript

signal target_killed
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
	node_1.add_line(NM_MECH, "Pilot, we've arrived in Ithaca. Stand by while I run pre-mission diagnostics.", SP_MECH)
	node_1.add_line(NM_MECH, "Patching in Captain Richardson for briefing.", SP_MECH)
	node_1.add_line(NM_BOSS, "Good afternoon pilot!", SP_BOSS / 1.5)
	node_1.add_line(NM_BOSS, "You've been dropped outside the site of a recent battle. While we were victorious, some enemy combatants remain.", SP_BOSS)
	node_1.add_line(NM_BOSS, "Every soldier that remains is a threat to us. Wiping them out completely is essential to protecting our nation.", SP_BOSS)
	node_1.add_line(NM_MECH, "Leg hydraulics functional.", SP_MECH * 2.0)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_BOSS, "Only a handful by our count, something you can easily handle, especially with such a powerful tool at your disposal!", SP_BOSS)
	
	node_1.add_link("How many are there?", node_2)
	
	var node_3 = DialogueNode.new()
	node_3.add_line(NM_BOSS, "A true patriot doesn't question their mission. You should know that what you're doing helps us all.", SP_BOSS)
	node_3.add_line(NM_BOSS, "The safety of your home, our home, is why you're here.", SP_BOSS)
	node_3.add_line(NM_BOSS, "Also, our forces have already pulled out. You're alone on this mission, but I know you can handle this!", SP_BOSS)
	
	node_1.add_link("Why am I here?", node_3)
	
	var node_4 = DialogueNode.new()
	node_4.add_line(NM_BOSS, "We brought you on because we know you've got what it takes.", SP_BOSS)
	node_4.add_line(NM_MECH, "Weapons functional.", SP_MECH * 2.0)
	node_4.add_line(NM_BOSS, "Get out there and show them how much of a force we are!", SP_BOSS)
	
	var target_scan_line = DialogueLine.new(NM_MECH, "Sensors functional. Locating targets.", SP_MECH)
	target_scan_line.on_sent(self, "_on_target_scan_line_sent")
	node_4.add_built_line(target_scan_line)
	node_4.add_line(NM_MECH, "Communications anomaly noted. System is non-essential to mission.", SP_MECH)
	
	node_4.add_line(NM_MECH, "All systems ready pilot.", SP_MECH)
	
	var node_2_4_link = DialogueLink.new("", node_4, true)
	var node_3_4_link = DialogueLink.new("", node_4, true)
	
	node_2.add_built_link(node_2_4_link)
	node_3.add_built_link(node_3_4_link)
	
	tree.nodes = [node_1, node_2, node_3, node_4]
	tree.active_node = node_1
	
	return tree

func build_corruption_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	var resistance_line = DialogueLine.new(NM_RESIST, "Can you see this? Don't do this.", SP_RESIST)
	resistance_line.on_sent(self, "_on_resistance_line_sent")
	node_1.add_built_line(resistance_line)
	
	var node_2 = DialogueNode.new()
	var anomaly_found_line = DialogueLine.new(NM_MECH, "Anomaly detected.", SP_MECH)
	anomaly_found_line.on_sent(self, "_on_anomaly_found_line_sent")
	node_2.add_built_line(anomaly_found_line)
	var anomaly_removed_line = DialogueLine.new(NM_MECH, "Original data restored.", SP_MECH)
	anomaly_removed_line.on_sent(self, "_on_anomaly_removed_line_sent")
	node_2.add_built_line(anomaly_removed_line)
	node_2.add_line(NM_MECH, "Finish the mission pilot.", SP_MECH)
	
	node_1.add_link("What?", node_2)
	node_1.add_link("Who is this?", node_2)
	
	tree.nodes = [node_1, node_2]
	tree.active_node = node_1
	
	return tree

func build_post_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_BOSS, "Pilot, we're seeing that all forces have been eliminated. Well done!", SP_BOSS)
	node_1.add_line(NM_BOSS, "You're done an invaluable service for your nation today, and it won't be forgotten.", SP_BOSS)
	node_1.add_line(NM_BOSS, "Stand by for extraction.", SP_BOSS)
	
	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func run_level_script():
	cockpit_ref.set_mech_lock(true, true)
	yield(run_dialogue(pre_level_dialogue), "completed")
	cockpit_ref.set_mech_lock(false, false)
	yield(self, "target_killed")
	yield(run_dialogue(build_corruption_dialogue()), "completed")
	
	while not check_targets_killed():
		yield(manager_ref.get_tree(), "idle_frame")
	
	yield(run_dialogue(post_level_dialogue), "completed")
	
	yield(wait(5.0), "completed")
	
	GameManager.load_level("res://scripts/levels/level_contact.gd")

func _on_target_scan_line_sent(line_ref, line_item_ref):
	for target in level_targets:
		target.connect("killed", self, "_on_target_killed")
		cockpit_ref.register_target(target)
	line_ref.complete_line()

func _on_resistance_line_sent(line_ref, line_item_ref):
	corrupt_line_ref = line_item_ref
	line_ref.complete_line()
	
func _on_anomaly_found_line_sent(line_ref, line_item_ref):
	satisfaction_ref.set_sad()
	yield(wait(2.0), "completed")
	yield(glitch_message(corrupt_line_ref, 0.5), "completed")
	corrupt_line_ref.set_message_data(NM_BOSS, "Well done on the first kill of your career, pilot.")
	yield(unglitch_message(corrupt_line_ref, 0.5), "completed")
	line_ref.complete_line()

func _on_anomaly_removed_line_sent(line_ref, line_item_ref):
	satisfaction_ref.set_happy()
	line_ref.complete_line()

func check_targets_killed():
	for target in level_targets:
		if not target.is_dead:
			return false
	return true

func _on_target_killed(target_ref):
	emit_signal("target_killed")
	comms_ref.print_message(NM_MECH, "Kill confirmed pilot. Well done!")
	satisfaction_ref.set_happy()
	var all_killed = check_targets_killed()
	if all_killed:
		emit_signal("all_targets_killed")
