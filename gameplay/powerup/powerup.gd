class_name Powerup
extends Area2D

@export var power_name: String
@export var color_index: int
@onready var pickup: AudioStream = load("res://gameplay/audio/effect/pickup.wav")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.material.set_shader_parameter("color", color_index)
	#$AnimatedSprite2D.play("default")

var collect_timer: float = 0
var collected: bool = false
func collect(delta: float):
	if collect_timer == 0:
		PowerupPlayer.play()
	if collect_timer >= 1.0:
		queue_free()
	else:
		collect_timer += delta * 2.0
		$ColorRect.material.set_shader_parameter("collect_timer", collect_timer)
		
func _process(_delta: float) -> void:
	if collected:
		collect(_delta)
		return
	for body in get_overlapping_bodies():
		if body.get_class() == "CharacterBody2D":
			body.powers[power_name] = true
			collected = true;
			collect(_delta)
