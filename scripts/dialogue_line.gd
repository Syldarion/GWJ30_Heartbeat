class_name DialogueLine
extends Resource

signal line_sent(item_ref)

export(String) var speaker
export(String) var line

var corrupted_speaker
var corrupted_line

func _init(s="", l=""):
	speaker = s
	line = l

func send_line(line_item_ref):
	emit_signal("line_sent", line_item_ref)
