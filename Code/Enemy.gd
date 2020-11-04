extends KinematicBody2D

var facing = Vector2.ZERO
var direction = Vector2.ZERO
var speed = 100


func _ready():
	$Timer.start()

func _process(delta):
	direction = move_and_slide(movement(delta))/speed
	if direction == Vector2.ZERO:
		change_direction()

func movement(delta):
	return facing * speed

func change_direction():
	randomize()
	match (randi() % 5):
		0: facing = facing
		1: facing = Vector2.UP
		2: facing = Vector2.DOWN
		3: facing = Vector2.LEFT
		4: facing = Vector2.RIGHT
	

func _on_Timer_timeout():
	change_direction()
#	print(facing)
