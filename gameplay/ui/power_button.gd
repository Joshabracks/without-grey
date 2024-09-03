class_name PowerButton
extends TextureRect

@export var is_active: bool = false
var offset: float = -45.0
#@onready var origin_x: float = viewport_position.x
func _ready() -> void:
	#if is_active:
		#offset = 5.0
	#else:
		#offset = -45.0
	material = load("res://gameplay/ui/power_button.tres").duplicate()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.game_over:
		is_active = false
	if is_active && offset < 5.0:
		offset += delta * 40
		if offset > 5.0:
			offset = 5.0
	elif !is_active && offset > -50.0:
		offset -= delta * 40
	material.set_shader_parameter("offset", offset)
