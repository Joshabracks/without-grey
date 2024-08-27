class_name Platform
extends Polygon2D

@export var cyan: bool
@export var magenta: bool
@export var yellow: bool
var frequency: float = randf_range(0.1, 0.25)
var angle: float = randf_range(0.0, 1.57079632679)
var emboss: float = randf_range(0.85, 0.95)

var body: StaticBody2D
var collision: CollisionPolygon2D

func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = load("res://gameplay/platform/platform.gdshader")
	material.set_shader_parameter("cyan", cyan)
	material.set_shader_parameter("magenta", magenta)
	material.set_shader_parameter("yellow", yellow)
	material.set_shader_parameter("frequency", frequency)
	material.set_shader_parameter("angle", angle)
	material.set_shader_parameter("emboss",emboss)
	var image_texture = ImageTexture.new()
	var img = Image.new().create(500, 500, false, Image.FORMAT_RGB8)

	image_texture.create_from_image(img)
	texture = image_texture
	body = StaticBody2D.new()
	collision = CollisionPolygon2D.new()
	collision.polygon = polygon
	add_child(body)
	body.add_child(collision)

#func _process(delta: float) -> void:
	#angle += delta * randf() * 0.01
	#material.set_shader_parameter("angle", angle)
