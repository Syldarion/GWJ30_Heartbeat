class_name WeaponStatus
extends Node

export(NodePath) var shell_sprite_path
export(NodePath) var loader_sprite_path
export(NodePath) var empty_sprite_path
export(NodePath) var extended_sprite_path
export(NodePath) var retracted_sprite_path
export(NodePath) var status_label_path

onready var shell_sprite = get_node(shell_sprite_path) as Sprite
onready var loader_sprite = get_node(loader_sprite_path) as Sprite
onready var empty_sprite = get_node(empty_sprite_path) as Sprite
onready var extended_sprite = get_node(extended_sprite_path) as Sprite
onready var retracted_sprite = get_node(retracted_sprite_path) as Sprite
onready var status_label = get_node(status_label_path) as Label


func _ready():
	pass

func update_status(loader_retracted, shell_empty, shell_loaded):
	var weapon_status = "Weapon Status: "
	
	if not shell_loaded:
		shell_sprite.modulate = Color(1.0, 1.0, 1.0, 0.1)
		empty_sprite.modulate = Color(1.0, 1.0, 1.0, 0.1)
		weapon_status += "No Shell"
	elif not shell_empty:
		shell_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		empty_sprite.modulate = Color(1.0, 1.0, 1.0, 0.1)
		weapon_status += "Shell Ready"
	else:
		shell_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		empty_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		weapon_status += "Shell Spent"
	
	if loader_retracted:
		retracted_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		extended_sprite.modulate = Color(1.0, 1.0, 1.0, 0.1)
		weapon_status += " | Loader Retracted"
	else:
		extended_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		retracted_sprite.modulate = Color(1.0, 1.0, 1.0, 0.1)
		weapon_status += " | Loader Extended"
	
	status_label.text = weapon_status
