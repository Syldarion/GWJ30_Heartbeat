class_name DialogueNode

extends Resource

export(Array, Resource) var lines
export(Array, Resource) var links

func _init():
	lines = []
	links = []

func add_built_line(line: DialogueLine):
	lines.append(line)

func add_line(speaker: String, line: String):
	var new_line = DialogueLine.new(speaker, line)
	lines.append(new_line)
	return new_line

func add_built_link(link: DialogueLink):
	links.append(link)

func add_link(text: String, linked_node: DialogueNode):
	var new_link = DialogueLink.new(text, linked_node)
	links.append(new_link)
	return new_link

func corrupt_line(line: DialogueLine, speaker, new_line):
	line.corrupted_speaker = speaker
	line.corrupted_line = new_line

func clean_line(line: DialogueLine):
	pass
