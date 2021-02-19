class_name TrainingLevel
extends LevelScript

var training_dummy = SensorTarget.new("Dummy", Vector2(5.0, 0.0))
var dummy_dead = false

func _init():
	level_name = "training_level"

func build_pre_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "Welcome Pilot! Stand by while I patch in Captain Richardson...", 1.0)
	node_1.add_line(NM_BOSS, "Good morning Pilot, and welcome to the program!", 3.0)
	
	var node_2a = DialogueNode.new()
	node_2a.add_line(NM_BOSS, "Oh, so enthusiastic, the company does know how to pick their recruits!", 2.0)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_BOSS, "Today, I'm going to be running you through basic training so that you are fully prepared to defeat our enemies!", 3.0)
	node_2.add_line(NM_BOSS, "I'm sure you are wondering why you cannot see out of your mech.", 3.0)
	node_2.add_line(NM_BOSS, "This is an older class of mech, retrofitted with your safety in mind!", 3.0)
	node_2.add_line(NM_BOSS, "All external ports have been closed up, and replaced with a state of the art sensor array.", 3.0)
	node_2.add_line(NM_BOSS, "With this machine, you have the power to protect not only our nation, but yourself!", 3.0)
	node_2.add_line(NM_BOSS, "But first, you need to know how to use it.", 1.0)
	
	var node_2_spawn_target_line = DialogueLine.new(NM_BOSS, "If you look at your sensor display below, you should see a target has just appeared.", 2.0)
	node_2_spawn_target_line.on_sent(self, "_on_node_2_spawn_target_line_sent")
	node_2_spawn_target_line.has_exec = true
	node_2.add_built_line(node_2_spawn_target_line)
	
	node_2.add_line(NM_BOSS, "In a moment, I will unlock your controls and talk you through destroying this target!", 2.0)
	node_2.add_line(NM_BOSS, "I want you to imagine that this target means you harm, just as our enemies do. Put all of your heart behind this!", 3.0)
	
	var node_1_2a_link = DialogueLink.new("Good morning Captain!", node_2a)
	var node_1_2_link = DialogueLink.new("[Say nothing]", node_2)
	node_1_2_link.skip_print = true
	var node_2a_2_link = DialogueLink.new("", node_2, true)
	
	node_1.add_built_link(node_1_2a_link)
	node_1.add_built_link(node_1_2_link)
	node_2a.add_built_link(node_2a_2_link)
	
	tree.nodes = [node_1, node_2a, node_2]
	tree.active_node = node_1
	
	return tree

func build_move_tutorial_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "Movement controls unlocked!", 1.0)
	node_1.add_line(NM_BOSS, "Pilot, you should now be able to move about in the mech.", 2.0)
	node_1.add_line(NM_BOSS, "You'll notice it has been fitted with a mouse and keyboard, to make its controls more familiar to you!", 3.0)
	node_1.add_line(NM_BOSS, "Go ahead and give it a try!", 2.0)
	node_1.add_line(NM_MECH, "Pilot, use [W] and [S] to move forward or backward.", 1.0)
	node_1.add_line(NM_MECH, "Use [A] and [D] to turn me left or right.", 1.0)
	
	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func build_shot_tutorial_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_BOSS, "Now that you've had a chance to move about, it's time to move on.", 2.0)
	node_1.add_line(NM_BOSS, "Return to the target, and we'll go through weapons training!", 2.0)
	node_1.add_line(NM_MECH, "Pilot, your target is at [5.0, 0.0]", 1.0)
	node_1.add_line(NM_BOSS, "Your central sensor is a standard heartbeat sensor, and should allow you to easily find targets!", 2.0)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_BOSS, "Don't worry, the target here is simply a simulation!", 1.0)
	node_2.add_line(NM_BOSS, "However, the people on the field will be very real, and you mustn't forget that they mean to kill you!", 2.0)
	node_2.add_line(NM_BOSS, "And more importantly, they mean to dismantle our beautiful nation!", 2.0)
	node_2.add_line(NM_BOSS, "Now... return to the target, and your mech will explain readying your weapon!", 2.0)
	
	node_2.add_line(NM_MECH, "Pilot, arming and firing your primary cannon is simple.", 1.0)
	node_2.add_line(NM_MECH, "The loader is currently retracted and empty.", 1.0)
	
	var load_line = DialogueLine.new(NM_MECH, "Load a new shell by pressing [R].", 2.0)
	load_line.on_sent(self, "_on_mech_load_line_sent")
	node_2.add_built_line(load_line)
	
	var extend_loader_line = DialogueLine.new(NM_MECH, "Extend the loader by pressing [T].", 2.0)
	extend_loader_line.on_sent(self, "_on_mech_extend_line_sent")
	node_2.add_built_line(extend_loader_line)
	
	node_2.add_line(NM_MECH, "The cannon is now ready to fire. Targets must be within the firing cone.", 1.0)
	
	var fire_line = DialogueLine.new(NM_MECH, "Fire the loaded shell by pressing [F].", 1.0)
	fire_line.on_sent(self, "_on_mech_fire_line_sent")
	node_2.add_built_line(fire_line)
	
	node_2.add_line(NM_MECH, "Now the cannon has an empty shell that must be ejected.", 1.0)
	
	var retract_line = DialogueLine.new(NM_MECH, "Retract the loader by pressing [T].", 2.0)
	retract_line.on_sent(self, "_on_mech_retract_line_sent")
	node_2.add_built_line(retract_line)
	
	var eject_line = DialogueLine.new(NM_MECH, "Eject the empty shell by pressing [Shift+R].", 2.0)
	eject_line.on_sent(self, "_on_mech_eject_line_sent")
	node_2.add_built_line(eject_line)
	
	node_2.add_line(NM_MECH, "That is the full process.", 1.0)
	node_2.add_line(NM_MECH, "If you missed, try again until they are dead.", 1.0)
	
	var node_1_2_link_a = DialogueLink.new("Heartbeat...?", node_2)
	var node_1_2_link_b = DialogueLink.new("[Say nothing]", node_2)
	node_1_2_link_b.skip_print = true
	
	node_1.add_built_link(node_1_2_link_a)
	node_1.add_built_link(node_1_2_link_b)
	
	tree.nodes = [node_1, node_2]
	tree.active_node = node_1
	
	return tree

func build_post_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_BOSS, "Well done pilot! I think you are going to do wonderfully out there.", 2.0)
	node_1.add_line(NM_BOSS, "In a moment, we'll be shutting down your mech.", 2.0)
	node_1.add_line(NM_BOSS, "You and it are being sent on a very important mission!", 2.0)
	node_1.add_line(NM_BOSS, "The entire nation is relying on your strength and resolve!", 2.0)
	node_1.add_line(NM_BOSS, "Get out there and show them our strength.", 2.0)

	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func wait_for_dummy_death():
	while not dummy_dead:
		yield(manager_ref.get_tree(), "idle_frame")
	yield(manager_ref.get_tree(), "idle_frame")

func run_level_script():
	cockpit_ref.set_mech_lock(true, true)
	yield(run_dialogue(build_pre_level_dialogue()), "completed")
	cockpit_ref.set_mech_lock(false, true)
	yield(run_dialogue(build_move_tutorial_dialogue()), "completed")
	yield(manager_ref.get_tree().create_timer(15.0), "timeout")
	cockpit_ref.set_mech_lock(false, false)
	yield(run_dialogue(build_shot_tutorial_dialogue()), "completed")
	yield(wait_for_dummy_death(), "completed")
	yield(run_dialogue(build_post_level_dialogue()), "completed")

func _on_node_2_spawn_target_line_sent(line_ref, line_item_ref):
	cockpit_ref.register_target(training_dummy)
	training_dummy.connect("killed", self, "_on_training_dummy_killed")
	line_ref.complete_line()

func _on_training_dummy_killed(target_ref):
	dummy_dead = true

func _on_mech_load_line_sent(line_ref, line_item_ref):
	yield(cockpit_ref, "shell_loaded")
	line_ref.complete_line()

func _on_mech_extend_line_sent(line_ref, line_item_ref):
	yield(cockpit_ref, "loader_extended")
	line_ref.complete_line()

func _on_mech_fire_line_sent(line_ref, line_item_ref):
	yield(cockpit_ref, "shell_fired")
	line_ref.complete_line()

func _on_mech_retract_line_sent(line_ref, line_item_ref):
	yield(cockpit_ref, "loader_retracted")
	line_ref.complete_line()

func _on_mech_eject_line_sent(line_ref, line_item_ref):
	yield(cockpit_ref, "shell_ejected")
	line_ref.complete_line()
