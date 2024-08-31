class_name LevelController
extends Node

@export var platform_container: Node
@export var player_controller: PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.process_mode = PROCESS_MODE_PAUSABLE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var is_paused = get_tree().paused
		if is_paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
	if get_tree().paused:
		return
	if Global.restart:
		Global.game_over = false
		Global.restart = false
		get_tree().reload_current_scene()
	for platform: Platform in platform_container.get_children():
		var player_block: bool = (player_controller.player_color == Global.CMY.CYAN && platform.cyan) || (player_controller.player_color == Global.CMY.MAGENTA && platform.magenta) || (player_controller.player_color == Global.CMY.YELLOW && platform.yellow)
		platform.collision.disabled = !player_block
	if $CharacterBody2D.powers["magenta"]:
		$ToolTips/Control/PowerButtons/cyan.is_active = true
		$ToolTips/Control/PowerButtons/magenta.is_active = true
	if $CharacterBody2D.powers["yellow"]:
		$ToolTips/Control/PowerButtons/yellow.is_active = true
	if $PlayerController.max_jumps > 1:
		$ToolTips/Control/PowerButtons/djump.is_active = true
