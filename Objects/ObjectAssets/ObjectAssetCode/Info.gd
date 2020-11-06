extends Control


func _ready():
	pass

func _process(delta):
	coordinates()

func coordinates():
	$Coordinates.text = "Touch Coords: "+Global.touch_coordinates

