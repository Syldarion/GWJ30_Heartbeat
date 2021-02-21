class_name DialogueLine
extends Resource

signal line_sent(line_ref, item_ref)

export(String) var speaker
export(String) var line
export(int) var characters_per_second
export(bool) var has_exec
export(bool) var completed

var corrupted_speaker
var corrupted_line

func _init(s, l, cps):
	speaker = s
	line = l
	characters_per_second = cps

func get_wait():
	return len(line) / characters_per_second

func send_line(line_item_ref):
	emit_signal("line_sent", self, line_item_ref)
	
func on_sent(obj_ref, obj_func):
	has_exec = true
	connect("line_sent", obj_ref, obj_func)

func complete_line():
	completed = true
