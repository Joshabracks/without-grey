class_name PlayerController
extends Node

enum ACTION {
	DEFAULT, ROLL, DASH, JUMP
}

@export var player: CharacterBody2D
@export var sprite: AnimatedSprite2D
var action: ACTION = ACTION.DEFAULT

var player_color: Global.CMY = Global.CMY.CYAN
var key_pressed_a: bool = false
var key_pressed_s: bool = false
var key_pressed_d: bool = false
var coyote_time: float = 0.0
var right: bool = true
var speed: float = 300.0
var jump_force: float = -400.0
var max_jumps: int = 1
var jumps: int = 0
var jumping: bool = false

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
	if key_pressed_a && !key_pressed_d && !key_pressed_s && player.powers.cyan:
		player_color = Global.CMY.CYAN
	elif key_pressed_s && !key_pressed_a && !key_pressed_a && player.powers.magenta:
		player_color = Global.CMY.MAGENTA
	elif key_pressed_d && !key_pressed_a && !key_pressed_s && player.powers.yellow:
		player_color = Global.CMY.YELLOW

func _animate(delta: float):
	sprite.flip_h = !right
	var idle: bool = player.velocity.y + abs(player.velocity.x) == 0
	if idle:
		sprite.play("idle")
		return
	if player.velocity.x != 0:
		right = player.velocity.x > 0
	var grounded: bool = player.is_on_floor()
	var right: bool = player.velocity.x > 0
	if grounded && action == ACTION.DEFAULT:
		sprite.play("run")
		return
	var up: bool = player.velocity.y > 0
	if !grounded && player.velocity.y > 0 && (coyote_time > 0.25 || action == ACTION.JUMP):
		sprite.play("jump_up")
		return
	if !grounded && player.velocity.y < 0 && (coyote_time > 0.25 || action == ACTION.JUMP):
		sprite.play("jump_down")
		return
	if !grounded && (coyote_time > 0.25 || action == ACTION.JUMP):
		sprite.play("jump_peak")
		return
	

func _physics_process(delta):
	# Change the color
	_change_color()
	
	sprite.material.set_shader_parameter("color", int(player_color))
	# Add the gravity.
	if !player.is_on_floor():
		player.velocity.y += gravity * delta
		coyote_time += delta
		if coyote_time > 0.15 && !jumping:
			jumping = true
			jumps += 1
	else:
		if action == ACTION.JUMP:
			action = ACTION.DEFAULT
		coyote_time = 0.0
		jump_force = -400.0
		jumps = 0
		jumping = false
	# Handle Jump.
	var jump_a: bool = player.is_on_floor()
	var jump_b: bool = coyote_time < 0.15
	var jump_c: bool = jumps < max_jumps
	if Input.is_action_just_pressed("ui_accept") && (jump_a || jump_b || jump_c):
		player.velocity.y = jump_force
		action = ACTION.JUMP
		jumping = true
		jumps += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		player.velocity.x = direction * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)

	player.move_and_slide()
	_animate(delta)
