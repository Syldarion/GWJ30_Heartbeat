class_name GlitchEffect
extends Control


export(Material) var glitch_material

var max_glitch_x = 32
var max_glitch_y = 8

var glitch_x setget set_glitch_x, get_glitch_x
var glitch_y setget set_glitch_y, get_glitch_y

# Called when the node enters the scene tree for the first time.
func _ready():
	glitch_material.set_shader_param("scr_tex_size", Vector2(1920, 1080))
	set_glitch_x(1)
	set_glitch_y(1)

func _process(delta):
	# var noise_image = glitch_noise.get_image(noise_size.x, noise_size.y)
	# texture = ImageTexture.new().create_from_image(noise_image)
	# glitch_material.set_shader_param("noise_tex", ImageTexture.new().create_from_image(noise_image))
	pass

func set_glitch_x(new_value):
	glitch_x = new_value
	glitch_material.set_shader_param("size_x", new_value)

func get_glitch_x():
	return glitch_x

func set_glitch_y(new_value):
	glitch_y = new_value
	glitch_material.set_shader_param("size_y", new_value)

func get_glitch_y():
	return glitch_y
	
func set_rect(new_rect_pos, new_rect_size):
	rect_global_position = new_rect_pos
	rect_size = new_rect_size

func set_glitch_percentage(percent):
	set_glitch_x(max_glitch_x * percent)
	set_glitch_y(max_glitch_y * percent)
