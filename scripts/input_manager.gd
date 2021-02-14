extends Node

func _ready():
	pass # Replace with function body.

func _input(event):
	if not (event is InputEventMouseMotion):
		print(event.as_text())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
