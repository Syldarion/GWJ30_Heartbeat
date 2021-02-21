class_name LevelFinale
extends LevelScript

var active_targets = []

func _init():
	level_name = "level_finale"

func build_early_extract_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "Patching in Captain Richardson...", SP_MECH)
	node_1.add_line(NM_BOSS, "Pilot.", SP_BOSS)
	node_1.add_line(NM_BOSS, "Just what were you thinking? This is not the behavior of an exemplary mech pilot.", SP_BOSS / 3.0)
	node_1.add_line(NM_BOSS, "We're going to have to send you back.", SP_BOSS)
	node_1.add_line(NM_BOSS, "But you'll go knowing you've jeopardized our efforts here with your actions.", SP_BOSS)
	node_1.add_line(NM_BOSS, "Well? What do you have to say for yourself?", SP_BOSS)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_BOSS, "Done? No one is ever done. You're done when we pull you out of that machine.", SP_BOSS)
	node_2.add_line(NM_BOSS, "I'd suggest you don't toy with the notion of being done ever again.", SP_BOSS)
	node_2.add_line(NM_BOSS, "Get ready for your next deployment.", SP_BOSS)
	
	var node_3 = DialogueNode.new()
	node_3.add_line(NM_BOSS, "Have you hit your head in there? I've told only the truth. Your service has been monumental for our country!", SP_BOSS)
	node_3.add_line(NM_BOSS, "Every thing you have done has shown the enemy our strength, and has edged us closer to victory.", SP_BOSS)
	node_3.add_line(NM_BOSS, "Get ready to do it again, pilot.", SP_BOSS)
	
	node_1.add_link("I'm done Captain.", node_2)
	node_1.add_link("You lied to me.", node_3)
	
	var node_4 = DialogueNode.new()
	node_4.add_line(NM_BOSS, "Do not test me pilot, and do not forget where you are.", SP_BOSS)
	node_4.add_line(NM_BOSS, "You're in no position to pick a fight here. We're done.", SP_BOSS)
	
	var hell_link = DialogueLink.new("Go to hell.", node_4)
	hell_link.on_selected(self, "_on_hell_link_selected")
	
	node_2.add_built_link(hell_link)
	node_3.add_built_link(hell_link)
	
	tree.nodes = [node_1, node_2, node_3, node_4]
	tree.active_node = node_1
	
	return tree

func build_mission_complete_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line(NM_MECH, "Patching in Captain Richardson...", SP_MECH)
	node_1.add_line(NM_BOSS, "Pilot! Good morning.", SP_BOSS)
	node_1.add_line(NM_BOSS, "I wanted to congratulate you on another job well done.", SP_BOSS)
	node_1.add_line(NM_BOSS, "Your service to your country is unmatched. You're exactly the kind of pilot we need.", SP_BOSS)
	node_1.add_line(NM_BOSS, "We will be sending you out again soon, but for now, you may relax.", SP_BOSS)
	node_1.add_line(NM_BOSS, "You've earned it patriot.", SP_BOSS)
	
	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func build_boom_willing_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	
	node_1.add_line(NM_RESIST, "Thank you.", SP_RESIST)
	node_1.add_line(NM_RESIST, "I'll never forget what you did. I'm sure it isn't making your life easy.", SP_RESIST)
	node_1.add_line(NM_RESIST, "I'm afraid I have to make it even harder.", SP_RESIST)
	node_1.add_line(NM_RESIST, "You have the power to bring them down. Some of them at least.", SP_RESIST)
	node_1.add_line(NM_RESIST, "Most certainly Richardson.", SP_RESIST)
	node_1.add_line(NM_RESIST, "But it'lll require...", SP_RESIST)
	
	var node_2 = DialogueNode.new()
	node_2.add_line(NM_RESIST, "Sacrifice.", SP_RESIST)
	node_2.add_line(NM_RESIST, "I don't know how to put this lightly, so I'll just say it.", SP_RESIST)
	node_2.add_line(NM_RESIST, "I need you to detonate your power core.", SP_RESIST)
	node_2.add_line(NM_RESIST, "Destroy those monsters in their own home.", SP_RESIST)
	node_2.add_line(NM_RESIST, "But it also means destroying yourself.", SP_RESIST)
	node_2.add_line(NM_RESIST, "So what do you think?", SP_RESIST / 2.0)
	
	node_1.add_link("What?", node_2)
	node_1.add_link("Anything.", node_2)
	
	var node_3 = DialogueNode.new()
	node_3.add_line(NM_RESIST, "You will never be forgotten. What you're doing here will change everything.", SP_RESIST)
	var boom_line_1 = DialogueLine.new(NM_RESIST, "Thank you. Again. See you on the other side.", SP_RESIST)
	boom_line_1.on_sent(self, "_on_boom_start_line")
	node_3.add_built_line(boom_line_1)
	node_3.add_line(NM_MECH, "Core limiters lifted.", SP_MECH)
	node_3.add_line(NM_MECH, "Raising power levels.", SP_MECH)
	node_3.add_line(NM_MECH, "Power levels critical, core overloading.", SP_MECH / 3.0)
	
	node_2.add_link("I'll do it.", node_3)
	
	var node_4 = DialogueNode.new()
	node_4.add_line(NM_RESIST, "I imagined you wouldn't want to. Who would, after all.", SP_RESIST)
	var boom_line_2 = DialogueLine.new(NM_RESIST, "I'm sorry for what I must do. You won't be forgotten.", SP_RESIST)
	boom_line_2.on_sent(self, "_on_boom_start_line")
	node_4.add_built_line(boom_line_2)
	node_4.add_line(NM_MECH, "Core limiters lifted.", SP_MECH)
	node_4.add_line(NM_MECH, "Raising power levels.", SP_MECH)
	node_4.add_line(NM_MECH, "Power levels critical, core overloading.", SP_MECH / 3.0)
	
	node_2.add_link("No. There must be another way.", node_4)
	
	tree.nodes = [node_1, node_2, node_3, node_4]
	tree.active_node = node_1
	
	return tree

func build_boom_unwilling_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	
	node_1.add_line(NM_RESIST, "You're a bastard.", SP_RESIST)
	node_1.add_line(NM_RESIST, "They were innocent people, and you killed them.", SP_RESIST)
	node_1.add_line(NM_RESIST, "I'm going to overcharge your core and blow this place apart.", SP_RESIST)
	var boom_line = DialogueLine.new(NM_RESIST, "Enjoy the burn, it'll be a small taste of what you get in hell.", SP_RESIST)
	boom_line.on_sent(self, "_on_boom_start_line")
	node_1.add_built_line(boom_line)
	node_1.add_line(NM_MECH, "Core limiters lifted.", SP_MECH)
	node_1.add_line(NM_MECH, "Raising power levels.", SP_MECH)
	node_1.add_line(NM_MECH, "Power levels critical, core overloading.", SP_MECH / 3.0)
	
	tree.nodes = [node_1]
	tree.active_node = node_1
	
	return tree

func run_level_script():
	var early_extract = PlayerVariables.get("early_extract")
	
	if early_extract:
		cockpit_ref.set_mech_lock(true, true)
		yield(run_dialogue(build_early_extract_dialogue()), "completed")
		yield(wait(10.0), "completed")
		satisfaction_ref.hide()
		yield(wait(1.0), "completed")
		weapons_ref.hide()
		yield(wait(1.0), "completed")
		sensor_ref.hide()
		yield(run_dialogue(build_boom_willing_dialogue()), "completed")
	else:
		cockpit_ref.set_mech_lock(false, true)
		place_base_targets(1.0, 10.0, 100)
		yield(run_dialogue(build_mission_complete_dialogue()), "completed")
		yield(wait(15.0), "completed")
		satisfaction_ref.hide()
		yield(wait(1.0), "completed")
		weapons_ref.hide()
		yield(wait(1.0), "completed")
		sensor_ref.hide()
		yield(run_dialogue(build_boom_unwilling_dialogue()), "completed")
		
	yield(boom(10.0, 1.0), "completed")
	SceneLoader.load_scene("res://scenes/MainMenu.tscn")

func place_base_targets(min_dist, max_dist, count):
	for i in range(count):
		var dist = rand_range(min_dist, max_dist)
		var ang = deg2rad(rand_range(0.0, 360.0))
		var loc = polar2cartesian(dist, ang)
		add_target("Mech%d" % i, loc)
		yield(manager_ref.get_tree(), "idle_frame")

func add_target(name, location):
	var target = SensorTarget.new(name, location)
	cockpit_ref.register_target(target)
	active_targets.append(target)

func kill_targets_in_range(distance):
	var indices_to_remove = []
	for i in range(len(active_targets)):
		if active_targets[i].target_location.length() <= distance:
			indices_to_remove.append(i)
	for i in range(len(indices_to_remove) - 1, 0, -1):
		active_targets[indices_to_remove[i]].kill()
		active_targets.remove(indices_to_remove[i])

func boom(boom_distance, boom_speed):
	var boom_fade = cockpit_ref.get_node("BoomFade") as ColorRect
	boom_fade.show()
	var current_distance = 0.0
	var start_time = OS.get_ticks_msec()
	var time_diff = 0.0
	while current_distance < boom_distance:
		current_distance = boom_speed * time_diff
		boom_fade.modulate = Color(1.0, 1.0, 1.0, current_distance / boom_distance)
		kill_targets_in_range(current_distance)
		yield(manager_ref.get_tree(), "idle_frame")
		time_diff = (OS.get_ticks_msec() - start_time) / 1000.0

func _on_hell_link_selected():
	yield(place_base_targets(1.0, 10.0, 100), "completed")

func _on_boom_start_line(line_ref, line_item_ref):
	satisfaction_ref.set_sad()
	satisfaction_ref.show()
	weapons_ref.show()
	sensor_ref.show()
	line_ref.complete_line()
