extends AudioStreamPlayer

@export var start: AudioStream
@export var body: AudioStream
@export var end: AudioStream

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#stream = start
	#play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !playing:
		if stream == null:
			stream = start
		elif Global.game_over:
			if stream == end:
				stream = null
				Global.restart = true
			else:
				stream = end
		else:
			stream = body
		play()
