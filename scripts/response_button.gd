extends Button

class_name ResponseButton

signal selected(button)

func _ready():
	connect("pressed", self, "_on_Button_pressed")

func _process(delta):
	pass
	
func _on_Button_pressed():
	emit_signal("selected", self)
