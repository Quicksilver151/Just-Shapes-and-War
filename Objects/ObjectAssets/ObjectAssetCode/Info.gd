extends Control


func _ready():
	pass

func _process(delta):
	coordinates()

func coordinates():
	$Coordinates.text = Global.touch_coordinates

