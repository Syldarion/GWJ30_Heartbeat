class_name DialogueLine
extends Resource

signal line_sent(line_ref, item_ref)

export(String) var speaker
export(String) var line
export(int) var wait
export(bool) var has_exec
export(bool) var completed

var corrupted_speaker
var corrupted_line

func _init(s="", l=""):
	speaker = s
	line = l

func send_line(line_item_ref):
	emit_signal("line_sent", self, line_item_ref)

func complete_line():
	completed = true
