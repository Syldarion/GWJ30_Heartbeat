extends Camera2D

class_name ImpulseCamera

export var decay = 0.8
export var max_offset = Vector2(0, 75)
export var max_impulse = 1.0

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

var impulse_strength = 0.0
var impulse_power = 2

func _ready():
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta):
	if impulse_strength > 0.0:
		impulse_strength = max(impulse_strength - decay * delta, 0.0)
		shake()

func shake():
	noise_y += 1
	var amount = pow(impulse_strength, impulse_power)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed * 2, noise_y)

func add_impulse(amount):
	impulse_strength = min(impulse_strength + amount, max_impulse)
