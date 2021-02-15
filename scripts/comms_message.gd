extends Node

class_name CommsMessage

export(NodePath) var message_icon_path
export(NodePath) var name_label_path
export(NodePath) var message_label_path

onready var message_icon = get_node(message_icon_path) as TextureRect
onready var name_label = get_node(name_label_path) as Label
onready var message_label = get_node(message_label_path) as Label


func _ready():
	pass

func set_message_data(sender, message):
	name_label.text = sender
	message_label.text = message
