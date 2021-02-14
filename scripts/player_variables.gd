extends Node

class PlayerVariable:
	var value = null
	var persistent = false


var variables = {}
var save_location = "user://player_data.save"

func _ready():
	pass
	
func get(var_path: String):
	if var_path in variables:
		return variables[var_path].value
	print("Could not find %s in player_variables!" % var_path)
	return null
	
func set(var_path: String, value, persist=null):
	if (var_path in variables) == false:
		variables[var_path] = PlayerVariable.new()
		
	variables[var_path].value = value
	
	if persist != null:
		variables[var_path].persistent = persist

func has(var_path: String):
	return var_path in variables

func save():
	var save_data = {}
	
	# get persistent values
	for var_key in variables:
		if not variables[var_key].persistent:
			continue
		save_data[var_key] = variables[var_key].value
	
	# save to file
	var save_file = File.new()
	save_file.open(save_location, File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()
	
func load():
	var save_file = File.new()
	
	if not save_file.exists(save_location):
		return
	
	save_file.open(save_location, File.READ)
	
	while save_file.get_position() < save_file.get_len():
		var save_data = parse_json(save_file.get_line())
		
		for key in save_data:
			set(key, save_data[key], true)
	
	save_file.close()
