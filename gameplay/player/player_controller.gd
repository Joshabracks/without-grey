class_name PlayerController
extends Node

enum ACTION {
	DEFAULT, ROLL, DASH, JUMP
}

@export var player: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var player_audio: AudioStreamPlayer2D
@export var audio_jump: Array[AudioStream]
@export var audio_step: Array[AudioStream]
@export var audio_landing: Array[AudioStream]
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
func _ready() -> void:
	sprite.frame_changed.connect(_on_frame_changed)
	#sprite.animation_changed.connect(_on_animation_changed)
	
#func _on_animation_changed() -> void:
	#match sprite.animation:
		#"jump_up":
			#player_audio.stream = audio_jump[randi_range(0, len(audio_jump) - 1)]
			#player_audio.pitch_scale = 2.5
			#player_audio.volume_db = -25.0
			#player_audio.play()

func _on_frame_changed() -> void:
	if player_color == Global.CMY.WHITE:
		return
	match [sprite.animation, sprite.frame]:
		["run", 0], ["run", 4 ]:
			player_audio.stream = audio_step[randi_range(0, len(audio_step) - 1)]
			player_audio.pitch_scale = 1.0
			player_audio.volume_db = 0.0
			player_audio.play()

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
		action = ACTION.JUMP
		return
	if !grounded && player.velocity.y < 0 && (coyote_time > 0.25 || action == ACTION.JUMP):
		sprite.play("jump_down")
		action = ACTION.JUMP
		return
	if !grounded && (coyote_time > 0.25 || action == ACTION.JUMP):
		sprite.play("jump_peak")
		action = ACTION.JUMP
		return
	

var end_color: Global.CMY = Global.CMY.CYAN

func _physics_process(delta):
	if player.powers.end:
		Global.game_over = true
		player_color = Global.CMY.WHITE
		end_color += 1
		if end_color > Global.CMY.YELLOW:
			end_color = Global.CMY.CYAN
		sprite.material.set_shader_parameter("color", int(end_color))
		player.move_and_slide()
		return
	if player.powers["double-jump"]:
		max_jumps += 1
		player.powers["double-jump"] = false;
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
			player_audio.stream = audio_landing[randi_range(0, len(audio_landing) - 1)]
			player_audio.pitch_scale = 1.1
			player_audio.volume_db = -2.0
			player_audio.play()
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
		player_audio.stream = audio_jump[randi_range(0, len(audio_jump) - 1)]
		player_audio.pitch_scale = 1.1
		player_audio.volume_db = -18.0
		player_audio.play()
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
