class_name PlayerController
extends Node

enum ACTION {
	DEFAULT, ROLL, DASH
}

var action: ACTION = ACTION.DEFAULT

var player_color: Global.CMY = Global.CMY.CYAN
var key_pressed_a: bool = false
var key_pressed_s: bool = false
var key_pressed_d: bool = false
@onready var sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
var right: bool = true
# Called when the node enters the scene tree for the first time.
const SPEED = 300.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#func _ready() -> void:
	#pass # Replace with function body.

func _change_color():
	var a: bool = Input.is_key_pressed(KEY_A)
	var s: bool = Input.is_key_pressed(KEY_S)
	var d: bool = Input.is_key_pressed(KEY_D)
	if a && !key_pressed_a:
		key_pressed_a = true
	elif !a && key_pressed_a:
		key_pressed_a = false
	if d && !key_pressed_d:
		key_pressed_d = true
	elif !d && key_pressed_d:
		key_pressed_d = false
	if s && !key_pressed_s:
		key_pressed_s = true
	elif !s && key_pressed_s:
		key_pressed_s = false
	if key_pressed_a && !key_pressed_d && !key_pressed_s:
		player_color = Global.CMY.CYAN
	elif key_pressed_s && !key_pressed_a && !key_pressed_a:
		player_color = Global.CMY.MAGENTA
	elif key_pressed_d && !key_pressed_a && !key_pressed_s:
		player_color = Global.CMY.YELLOW

func _animate(delta: float):
	sprite.flip_h = !right
	var idle: bool = $CharacterBody2D.velocity.y + abs($CharacterBody2D.velocity.x) == 0
	if idle:
		sprite.play("idle")
		return
	if $CharacterBody2D.velocity.x != 0:
		right = $CharacterBody2D.velocity.x > 0
	var grounded: bool = $CharacterBody2D.is_on_floor()
	var right: bool = $CharacterBody2D.velocity.x > 0
	if grounded && action == ACTION.DEFAULT:
		sprite.play("run")
		return
	var up: bool = $CharacterBody2D.velocity.y > 0
	if !grounded && $CharacterBody2D.velocity.y > 0:
		sprite.play("jump_up")
		return
	if !grounded && $CharacterBody2D.velocity.y < 0:
		sprite.play("jump_down")
		return
	if !grounded:
		sprite.play("jump_peak")
		return
	

func _physics_process(delta):
	# Change the color
	_change_color()
	
	$CharacterBody2D/AnimatedSprite2D.material.set_shader_parameter("color", int(player_color))
	# Add the gravity.
	if !$CharacterBody2D.is_on_floor():
		$CharacterBody2D.velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") && $CharacterBody2D.is_on_floor():
		$CharacterBody2D.velocity.y = JUMP_FORCE

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		$CharacterBody2D.velocity.x = direction * SPEED
	else:
		$CharacterBody2D.velocity.x = move_toward($CharacterBody2D.velocity.x, 0, SPEED)

	$CharacterBody2D.move_and_slide()
	_animate(delta)
