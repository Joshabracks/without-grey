extends Sprite2D


var spectrum: AudioEffectInstance
var volume: float

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(2, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	volume = spectrum.get_magnitude_for_frequency_range(0, 100).length() * 10.0
	if volume > 0.15:
		scale = Vector2(1 + volume, 1 + volume)
	
