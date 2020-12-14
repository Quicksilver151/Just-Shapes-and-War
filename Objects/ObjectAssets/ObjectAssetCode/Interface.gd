extends MarginContainer

func _process(delta):
	$MarginContainer/VBoxContainer/DebugInfo/Coordinates.text = "Touch Coords: " + Global.touch_coordinates
	
	rect_size = get_viewport_rect().size
	

func _on_Exit_pressed():
	get_tree().quit()
