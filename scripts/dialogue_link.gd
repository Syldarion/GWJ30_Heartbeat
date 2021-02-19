class_name DialogueLink
extends Resource

signal link_selected

export(String) var link_text
export(Resource) var next_node
export(bool) var auto_complete
export(bool) var skip_print

func _init(lt="", nn=null, auto=false):
	link_text = lt
	next_node = nn
	auto_complete = auto

func _on_Response_Button_selected(button):
	emit_signal("link_selected")

func on_selected(obj_ref, obj_func):
	connect("link_selected", obj_ref, obj_func)
