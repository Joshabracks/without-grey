extends Polygon2D

@export var mat_template: ShaderMaterial
@export var cyan: bool
@export var magenta: bool
@export var yellow: bool
@export var frequency: float = randf_range(0.0, 1.0)
@export var angle: float = randf()


func _ready() -> void:
	material = mat_template.duplicate()
	material.set_shader_parameter("cyan", cyan)
	material.set_shader_parameter("magenta", magenta)
	material.set_shader_parameter("yellow", yellow)
	material.set_shader_parameter("frequency", frequency)
	material.set_shader_parameter("angle", angle)

#func _process(delta: float) -> void:
	#angle += delta * randf() * 0.01
	#material.set_shader_parameter("angle", angle)
