class_name LevelController
extends Node

@export var platform_container: Node
@export var player_controller: PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.restart:
		Global.game_over = false
		Global.restart = false
		get_tree().reload_current_scene()
	for platform: Platform in platform_container.get_children():
		var player_block: bool = (player_controller.player_color == Global.CMY.CYAN && platform.cyan) || (player_controller.player_color == Global.CMY.MAGENTA && platform.magenta) || (player_controller.player_color == Global.CMY.YELLOW && platform.yellow)
		platform.collision.disabled = !player_block

