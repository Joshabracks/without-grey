class_name PlayerController
extends Node

var player_color: Global.CMY = Global.CMY.CYAN
var key_pressed_a: bool = false
var key_pressed_d: bool = false
# Called when the node enters the scene tree for the first time.
const SPEED = 300.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#func _ready() -> void:
	#pass # Replace with function body.


func _physics_process(delta):
	# Change the color
	var a: bool = Input.is_key_pressed(KEY_A)
	if a && !key_pressed_a:
		key_pressed_a = true
		player_color -= 1
	elif !a && key_pressed_a:
		key_pressed_a = false
	var d: bool = Input.is_key_pressed(KEY_D)
	if d && !key_pressed_d:
		key_pressed_d = true
		player_color += 1
	elif !d && key_pressed_d:
		key_pressed_d = false
	if player_color < 0:
		player_color = Global.CMY.YELLOW
	if player_color > Global.CMY.YELLOW:
		player_color = Global.CMY.CYAN
	$CharacterBody2D/Sprite2D.material.set_shader_parameter("color", int(player_color))
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
