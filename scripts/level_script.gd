class_name LevelScript

var level_name

var pre_level_dialogue
var post_level_dialogue
var level_targets = []

var cockpit_ref
var comms_ref

func _init():
	level_name = "NONE"
	pre_level_dialogue = build_pre_level_dialogue()
	post_level_dialogue = build_post_level_dialogue()
	
func setup_references(cockpit: Cockpit, comms: CommsPanel):
	# Set up all references to game systems the level script might need
	# This definitely isn't the best way to do this, but it'll have to do
	# for the jam
	cockpit_ref = cockpit
	comms_ref = comms
	
func run_level_script():
	pass

func build_pre_level_dialogue() -> DialogueTree:
	# Build the dialogue tree for the beginning of the mission
	return DialogueTree.new()

func build_post_level_dialogue() -> DialogueTree:
	# Build the dialogue tree for the end of the mission
	return DialogueTree.new()

func setup_targets():
	# Spawn all targets in the level and set up appropriate events
	pass
