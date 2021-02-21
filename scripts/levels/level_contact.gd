class_name LevelContact
extends LevelScript

signal target_killed
signal all_targets_killed

var level_targets
var pre_level_dialogue
var post_level_dialogue

var waiting
var corrupt_line_ref
var early_extract

func _init():
	level_name = "level_contact"
	
	level_targets = build_target_list()
	pre_level_dialogue = build_pre_level_dialogue()
	post_level_dialogue = build_post_level_dialogue()
	
func build_target_list():
	var targets = [
		SensorTarget.new("Myles Pattesley", Vector2(-10.5, 10)),
		SensorTarget.new("Judeth Reynes", Vector2(-10.4, 10.2)),
		SensorTarget.new("Marian Lowthe", Vector2(-10.2, 10)),
		SensorTarget.new("Dorothee Sibill", Vector2(-9.8, 10.1)),
		SensorTarget.new("Abraham Dryden", Vector2(-9.6, 10)),
		SensorTarget.new("Mark Lewys", Vector2(10, 10)),
		SensorTarget.new("Philip Goodwyn", Vector2(10.5, 9.8)),
		SensorTarget.new("Jeffrey Dalison", Vector2(-5.4, 18)),
		SensorTarget.new("Samuell Poulet", Vector2(15.2, 18)),
		SensorTarget.new("Joseph Canon", Vector2(-8.3, 24.3)),
		SensorTarget.new("Bartram Froste", Vector2(-7.6, 24.4)),
		SensorTarget.new("Osmund Warbulton", Vector2(-8, 24)),
		SensorTarget.new("Hannah Isley", Vector2(5, 24)),
		SensorTarget.new("Sarah Clavell", Vector2(5.6, 23.5)),
		SensorTarget.new("Faith Glenham", Vector2(6.2, 24.3))
	]
	
	return targets

func build_pre_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "Running pre-mission diagnostics.", SP_MECH)
	node_1.add_line(NM_BOSS, "Good evening pilot! We've sent you deeper into Ithaca for an even more critical mission.", SP_BOSS)
	node_1.add_line(NM_BOSS, "You've been dropped outside one of their weapons facilities.", SP_BOSS)
	node_1.add_line(NM_BOSS, "This base will be easily handled by a proven pilot such as yourself!", SP_BOSS)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_BOSS, "As I'm sure you know, there's no need to worry about the walls of the facility.", SP_BOSS)
	node_2.add_line(NM_BOSS, "The mech is powerful enough to drive through any of them!", SP_BOSS)
	node_2.add_line(NM_BOSS, "Take that power and destroy them, for our future.", SP_BOSS)
	
	node_1.add_link("How will I see the walls?", node_2)
	
	tree.nodes = [node_1, node_2]
	tree.active_node = node_1
	
	return tree

func build_overtake_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "Diagnostics complete. Communications anomaly present.", SP_MECH)
	var fixing_anomaly_line = DialogueLine.new(NM_MECH, "Fixing anomaly...", SP_MECH)
	fixing_anomaly_line.on_sent(self, "_on_fixing_anomaly_line_sent")
	node_1.add_built_line(fixing_anomaly_line)
	node_1.add_line(NM_RESIST, "Don't freak out, I'm just shutting down your mech real quick.", SP_RESIST)
	
	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func build_resistance_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_RESIST, "There, that should give us some time.", SP_RESIST)
	node_1.add_line(NM_RESIST, "I know I'm basically holding you hostage right now, but please listen to me.", SP_RESIST)
	
	var node_2a = DialogueNode.new()
	node_2a.add_line(NM_RESIST, "That's unimportant right now, but you can call me Circe. Now listen.", SP_RESIST)
	
	var node_2b = DialogueNode.new()
	node_2b.add_line(NM_RESIST, "Please, I know this is a bad way to get your trust, but I need you to understand what's happening here.", SP_RESIST)
	
	node_1.add_link("Who are you?", node_2a)
	node_1.add_link("Release my mech immediately.", node_2b)
	
	var node_3 = DialogueNode.new()
	node_3.add_line(NM_RESIST, "They're lying to you. Richardson and the nation they stand for, that you stand for.", SP_RESIST)
	node_3.add_line(NM_RESIST, "I've been monitoring this mech, I've seen what they've told you.", SP_RESIST)
	node_3.add_line(NM_RESIST, "Yes, there's undoubtedly a war, but you aren't making the impact you might think you are.", SP_RESIST)
	node_3.add_line(NM_RESIST, "This isn't a weapons facility, or anything remotely close.", SP_RESIST)
	node_3.add_line(NM_RESIST, "Right now you and your mech are facing down a defenseless village.", SP_RESIST)
	node_3.add_line(NM_RESIST, "These people are innocent. They have nothing to do with this conflict.", SP_RESIST)
	
	node_2a.add_link("", node_3, true)
	node_2b.add_link("", node_3, true)
	
	var node_4a = DialogueNode.new()
	node_4a.add_line(NM_RESIST, "It is. It's hard to believe, I know. But you have to.", SP_RESIST)
	node_4a.add_line(NM_RESIST, "Surely you've felt that doubt, even before you enlisted.", SP_RESIST)
	node_4a.add_line(NM_RESIST, "Why else would they hide your own actions from you?", SP_RESIST)
	
	var node_4b = DialogueNode.new()
	node_4b.add_line(NM_RESIST, "It may just be a mission to you, but these are lives that do not need to be lost.", SP_RESIST)
	node_4b.add_line(NM_RESIST, "Richardson is not acting in your best interest, or in your country's.", SP_RESIST)
	
	node_3.add_link("That can't be right.", node_4a)
	node_3.add_link("I'm doing my duty.", node_4b)
	
	var node_5 = DialogueNode.new()
	node_5.add_line(NM_RESIST, "I'm afraid I'm out of time. Take your mech back. I hope you make the right choice.", SP_RESIST)
	node_5.add_line(NM_RESIST, "I'll leave you with one last thing in the hope that it will sway you.", SP_RESIST)
	node_5.add_line(NM_RESIST, "Solomon Lloyd. Margerie Lloyd. Peter Hayes. You might not know these people, but you killed them yesterday.", SP_RESIST)
	node_5.add_line(NM_RESIST, "Goodbye.", SP_RESIST)
	
	node_4a.add_link("", node_5, true)
	node_4b.add_link("", node_5, true)
	
	tree.nodes = [node_1, node_2a, node_2b, node_3, node_4a, node_4b, node_5]
	tree.active_node = node_1
	
	return tree

func build_extract_choice_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "Anomaly fixed.", SP_MECH)
	var target_scan_line = DialogueLine.new(NM_MECH, "Displaying targets.", SP_MECH)
	target_scan_line.on_sent(self, "_on_target_scan_line_sent")
	node_1.add_built_line(target_scan_line)
	node_1.add_line(NM_MECH, "All systems ready pilot.", SP_MECH)
	
	var node_2a = DialogueNode.new()
	node_2a.add_line(NM_MECH, "Warning pilot, targets still remain on the field. This will reflect poorly on your record.", SP_MECH)
	
	var node_2b = DialogueNode.new()
	var continue_line = DialogueLine.new(NM_MECH, "Acknowledged. Proceed with the mission pilot.", SP_MECH)
	continue_line.on_sent(self, "_on_continue_line_sent")
	node_2b.add_built_line(continue_line)
	
	var extract_link = DialogueLink.new("Take us home.", node_2a)
	extract_link.on_selected(self, "_on_extract_link_selected")
	node_1.add_built_link(extract_link)
	var finish_link = DialogueLink.new("Let's finish this.", node_2b)
	finish_link.on_selected(self, "_on_finish_link_selected")
	node_1.add_built_link(finish_link)
	
	tree.nodes = [node_1, node_2a, node_2b]
	tree.active_node = node_1
	
	return tree

func build_post_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_BOSS, "Pilot, you continue to exceed our expectations.", SP_BOSS)
	node_1.add_line(NM_BOSS, "You are a shining example of what it means to serve our country.", SP_BOSS)
	node_1.add_line(NM_BOSS, "Let's get you back home for some rest. Stand by for extraction.", SP_BOSS)
	
	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func run_level_script():
	cockpit_ref.set_mech_lock(true, true)
	yield(run_dialogue(pre_level_dialogue), "completed")
	cockpit_ref.set_mech_lock(false, false)
	
	yield(run_dialogue(build_overtake_dialogue()), "completed")
	
	yield(wait(5.0), "completed")
	
	satisfaction_ref.hide()
	yield(wait(1.0), "completed")
	weapons_ref.hide()
	yield(wait(1.0), "completed")
	sensor_ref.hide()
	
	yield(run_dialogue(build_resistance_dialogue()), "completed")
	
	yield(wait(5.0), "completed")
	
	satisfaction_ref.show()
	weapons_ref.show()
	sensor_ref.show()
	
	yield(run_dialogue(build_extract_choice_dialogue()), "completed")
	yield(wait(5.0), "completed")
	
	if not early_extract:
		# this is the full-completion route
		while not check_targets_killed():
			yield(manager_ref.get_tree(), "idle_frame")
		
		yield(run_dialogue(post_level_dialogue), "completed")
		
		yield(wait(5.0), "completed")
	
	GameManager.load_level("res://scripts/levels/level_finale.gd")

func _on_target_scan_line_sent(line_ref, line_item_ref):
	for target in level_targets:
		target.connect("killed", self, "_on_target_killed")
		cockpit_ref.register_target(target)
	line_ref.complete_line()
	
func _on_fixing_anomaly_line_sent(line_ref, line_item_ref):
	yield(wait(2.0), "completed")
	yield(glitch_message(line_item_ref, 0.5), "completed")
	line_item_ref.set_message_data(NM_RESIST, "No so fast.")
	yield(unglitch_message(line_item_ref, 0.5), "completed")
	line_ref.complete_line()

func _on_anomaly_removed_line_sent(line_ref, line_item_ref):
	satisfaction_ref.set_happy()
	line_ref.complete_line()

func _on_continue_line_sent(line_ref, line_item_ref):
	yield(wait(2.0), "completed")
	yield(glitch_message(line_item_ref, 0.1), "completed")
	line_item_ref.set_message_data(NM_MECH, "KILL THEM ALL")
	yield(unglitch_message(line_item_ref, 0.1), "completed")
	yield(wait(1.0), "completed")
	yield(glitch_message(line_item_ref, 0.1), "completed")
	line_item_ref.set_message_data(NM_MECH, "Acknowledged. Proceed with the mission pilot.")
	yield(unglitch_message(line_item_ref, 0.1), "completed")
	line_ref.complete_line()

func _on_extract_link_selected():
	early_extract = true
	PlayerVariables.set("early_extract", true)
	satisfaction_ref.set_sad()

func _on_finish_link_selected():
	early_extract = false
	PlayerVariables.set("early_extract", false)
	satisfaction_ref.set_neutral()

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
