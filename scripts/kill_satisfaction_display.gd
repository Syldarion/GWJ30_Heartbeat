class_name KillSatisfactionDisplay
extends Node

export(NodePath) var happy_sprite_path
export(NodePath) var neutral_sprite_path
export(NodePath) var sad_sprite_path

onready var happy_sprite = get_node(happy_sprite_path) as Sprite
onready var neutral_sprite = get_node(neutral_sprite_path) as Sprite
onready var sad_sprite = get_node(sad_sprite_path) as Sprite

func _ready():
	pass

func set_happy():
	happy_sprite.show()
	neutral_sprite.hide()
	sad_sprite.hide()

func set_neutral():
	happy_sprite.hide()
	neutral_sprite.show()
	sad_sprite.hide()

func set_sad():
	happy_sprite.hide()
	neutral_sprite.hide()
	sad_sprite.show()

func set_none():
	happy_sprite.hide()
	neutral_sprite.hide()
	sad_sprite.hide()
