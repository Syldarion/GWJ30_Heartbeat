extends Node

class_name WeaponStatus

export(NodePath) var loader_status_path
export(NodePath) var empty_shell_path
export(NodePath) var ammo_loaded_path

export(Material) var active_mat
export(Material) var inactive_mat

onready var loader_status = get_node(loader_status_path) as Sprite
onready var empty_shell = get_node(empty_shell_path) as Sprite
onready var ammo_loaded = get_node(ammo_loaded_path) as Sprite


func _ready():
	pass

func update_status(loader_retracted, shell_empty, shell_loaded):
	if loader_retracted:
		loader_status.material = inactive_mat
	else:
		loader_status.material = active_mat
	
	if shell_empty:
		empty_shell.material = inactive_mat
	else:
		empty_shell.material = active_mat
	
	if shell_loaded:
		ammo_loaded.material = active_mat
	else:
		ammo_loaded.material = inactive_mat
