class_name TrainingLevel
extends LevelScript

func _init():
	level_name = "training_level"

func build_pre_level_dialogue():
	var tree = DialogueTree.new()
	
	var node_1 = DialogueNode.new()
	node_1.add_line("Mech", "Pilot, can you see this?")
	node_1.add_line("Mech", "Just say Yes or No.")
	
	var node_2 = DialogueNode.new()
	node_2.add_line("Mech", "Good. Running systems check...")
	
	var node_3 = DialogueNode.new()
	node_3.add_line("Mech", "Ha. Ha. Running systems check...")
	
	node_1.add_link("Yes", node_2)
	node_1.add_link("No", node_3)
	
	tree.nodes = [node_1, node_2, node_3]
	tree.active_node = node_1
	
	return tree

func build_post_level_dialogue():
	pass
