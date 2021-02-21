class_name TrainingLevel
extends LevelScript

var training_dummy = SensorTarget.new("Dummy", Vector2(5.0, 0.0))
var dummy_dead = false

func _init():
	level_name = "training_level"

func build_pre_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "Pilot, stand by while I patch in Captain Richardson.", SP_MECH)
	node_1.add_line(NM_BOSS, "Good morning Pilot, and welcome to the program!", SP_BOSS)
	
	var node_2a = DialogueNode.new()
	node_2a.add_line(NM_BOSS, "Oh, so enthusiastic, the company does know how to pick their recruits!", SP_BOSS)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_BOSS, "Today, I'll take you through basic training so that you are fully prepared to defeat our enemies!", SP_BOSS)
	node_2.add_line(NM_BOSS, "You're in an older Odysseus-class mech, retrofitted with your safety and comfort in mind!", SP_BOSS)
	node_2.add_line(NM_BOSS, "All external ports have been closed up, and replaced with a state of the art sensor array.", SP_BOSS)
	node_2.add_line(NM_BOSS, "In this machine, you will become a critical piece of the fight for our future!", SP_BOSS)
	node_2.add_line(NM_BOSS, "First, however, you need to know how to use it.", SP_BOSS)
	
	var node_2_spawn_target_line = DialogueLine.new(NM_BOSS, "A target should have just spawned on your sensor.", SP_BOSS)
	node_2_spawn_target_line.on_sent(self, "_on_node_2_spawn_target_line_sent")
	node_2.add_built_line(node_2_spawn_target_line)
	
	node_2.add_line(NM_BOSS, "In a moment, I will unlock your controls and we can start.", SP_BOSS)
	node_2.add_line(NM_BOSS, "I want you to imagine that this target means you harm, just as our enemies do.", SP_BOSS)
	node_2.add_line(NM_BOSS, "Put all of your heart behind this!", SP_BOSS)
	
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
	node_1.add_line(NM_MECH, "Movement controls unlocked.", SP_MECH)
	node_1.add_line(NM_BOSS, "Pilot, you should now be able to move the mech.", SP_BOSS)
	node_1.add_line(NM_BOSS, "You'll notice it has been fitted with a mouse and keyboard, to make its controls more familiar to you!", SP_BOSS)
	node_1.add_line(NM_BOSS, "Go ahead and give it a spin!", SP_BOSS)
	node_1.add_line(NM_MECH, "Pilot, use [W] and [S] to move forward or backward.", SP_MECH)
	node_1.add_line(NM_MECH, "Use [A] and [D] to turn left or right.", SP_MECH)
	
	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func build_shot_tutorial_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_BOSS, "Now that you've had a chance to move about, it's time to move on.", SP_BOSS)
	node_1.add_line(NM_BOSS, "Return to the target, and we'll go through weapons training!", SP_BOSS)
	node_1.add_line(NM_BOSS, "Your central sensor is a standard heartbeat sensor, and should allow you to easily find targets!", SP_BOSS)
	node_1.add_line(NM_MECH, "If you cannot find your targets, I can ping them for you if you press [E]", SP_MECH)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_BOSS, "Don't worry, the target here is simply a simulation!", SP_BOSS)
	node_2.add_line(NM_BOSS, "However, the people on the field will be very real, and you mustn't forget that they mean to kill you!", SP_BOSS)
	node_2.add_line(NM_BOSS, "And more importantly, they mean to dismantle our beautiful nation!", SP_BOSS)
	node_2.add_line(NM_BOSS, "Now, return to the target, and the mech will explain readying its weapon!", SP_BOSS)
	
	node_2.add_line(NM_MECH, "Pilot, arming and firing your primary cannon is simple.", SP_MECH)
	node_2.add_line(NM_MECH, "The loader is currently retracted and empty.", SP_MECH)
	
	var load_line = DialogueLine.new(NM_MECH, "Load a new shell by pressing [R].", SP_MECH)
	load_line.on_sent(self, "_on_mech_load_line_sent")
	node_2.add_built_line(load_line)
	
	var extend_loader_line = DialogueLine.new(NM_MECH, "Extend the loader by pressing [T].", SP_MECH)
	extend_loader_line.on_sent(self, "_on_mech_extend_line_sent")
	node_2.add_built_line(extend_loader_line)
	
	node_2.add_line(NM_MECH, "The cannon is now ready to fire. Targets must be within the firing cone.", SP_MECH)
	
	var fire_line = DialogueLine.new(NM_MECH, "Fire the loaded shell by pressing [F].", SP_MECH)
	fire_line.on_sent(self, "_on_mech_fire_line_sent")
	node_2.add_built_line(fire_line)
	
	node_2.add_line(NM_MECH, "Now the cannon has an empty shell that must be ejected.", SP_MECH)
	
	var retract_line = DialogueLine.new(NM_MECH, "Retract the loader by pressing [T].", SP_MECH)
	retract_line.on_sent(self, "_on_mech_retract_line_sent")
	node_2.add_built_line(retract_line)
	
	var eject_line = DialogueLine.new(NM_MECH, "Eject the empty shell by pressing [Shift+R].", SP_MECH)
	eject_line.on_sent(self, "_on_mech_eject_line_sent")
	node_2.add_built_line(eject_line)
	
	node_2.add_line(NM_MECH, "That is the full process.", SP_MECH)
	node_2.add_line(NM_MECH, "If you missed, try again until they are dead.", SP_MECH)
	
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
	node_1.add_line(NM_BOSS, "Well done pilot! I think you are going to do wonderfully out there.", SP_BOSS)
	node_1.add_line(NM_BOSS, "In a moment, we'll be shutting down your mech.", SP_BOSS)
	node_1.add_line(NM_BOSS, "You and it are being sent on a very important mission!", SP_BOSS)
	node_1.add_line(NM_BOSS, "The entire nation is relying on your strength and resolve!", SP_BOSS)
	node_1.add_line(NM_BOSS, "Godspeed pilot.", SP_BOSS)

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
	yield(wait(15.0), "completed")
	cockpit_ref.set_mech_lock(false, false)
	yield(run_dialogue(build_shot_tutorial_dialogue()), "completed")
	yield(wait_for_dummy_death(), "completed")
	yield(run_dialogue(build_post_level_dialogue()), "completed")
	yield(wait(5.0), "completed")
	
	GameManager.load_level("res://scripts/levels/level_01.gd")

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
