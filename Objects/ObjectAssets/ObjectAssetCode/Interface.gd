extends MarginContainer

func _process(delta):
	$VBoxContainer/DebugInfo/Coordinates.text = "Touch Coords: " + Global.touch_coordinates

func _on_Exit_pressed():
	get_tree().quit()
