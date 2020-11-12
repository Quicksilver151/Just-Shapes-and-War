extends Node

var player_coordinates = Vector2.ZERO
var touch_coordinates = ""

func _ready():
	pass

func _process(delta):
	if OS.get_name() == "Android":
		pass
	else:
		if Input.is_action_just_pressed("cmd_fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen
