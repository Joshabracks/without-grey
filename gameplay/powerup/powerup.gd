class_name Powerup
extends Area2D

@export var power_name: String
@export var color_index: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("color", color_index)
	$AnimatedSprite2D.play("default")

func collect():
	queue_free()

func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.get_class() == "CharacterBody2D":
			body.powers[power_name] = true
			collect()
