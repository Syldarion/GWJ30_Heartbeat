class_name DialogueLink
extends Resource

signal link_selected

export(String) var link_text
export(Resource) var next_node

func _init(lt="", nn=null):
	link_text = lt
	next_node = nn

func _on_Response_Button_selected(button):
	emit_signal("link_selected")
