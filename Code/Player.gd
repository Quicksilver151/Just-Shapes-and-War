extends KinematicBody2D

var direction = Vector2.ZERO
var current_direction = Vector2.ZERO

var touch_position = Vector2.ZERO
var drag_position = Vector2.ZERO

var x = 0
var y = 0

var touching = false

var dashing = false
var cooldown = false

export(float,0,1000,0.1) var speed = 350
export(float,0,1000,0.1) var friction = 15

export(PackedScene) var boost_particle:PackedScene

func _process(delta):
#	current_direction = move_and_slide(topdown_movement(speed,delta)) / speed
#	print(current_direction)
	move_and_slide(touch_screen_movement())
	
	if Input.is_action_just_pressed("dash") and !dashing and !cooldown and current_direction.length() >= 0.1:
		dashing = true
		dash()
		var instance = boost_particle.instance()
		add_child(instance)
		instance.emitting = true
		yield(get_tree().create_timer(3),"timeout")
		instance.queue_free()


func find_player_coordinates():
	Global.player_coordinates.x = floor(position.x/32)
	Global.player_coordinates.y = floor(position.y/32)
	print(Global.player_coordinates)

func topdown_movement(speed,delta):
	if !dashing:
		x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if current_direction.x == 0 or current_direction.y == 0:
		direction.x = lerp(direction.x,Vector2(x,y).x,friction*delta)
		direction.y = lerp(direction.y,Vector2(x,y).y,friction*delta)
	else:
		direction.x = lerp(direction.x,Vector2(x,y).normalized().x,friction*delta)
		direction.y = lerp(direction.y,Vector2(x,y).normalized().y,friction*delta)
	
#	print(direction *speed)
	return direction * speed
	

func dash():
	speed *= 4
	$PlayerEffects.play("transparent_cooldown")
	yield(get_tree().create_timer(0.25),"timeout")
	speed /= 4
	dashing = false
	cooldown = true
	yield(get_tree().create_timer(1),"timeout")
	cooldown = false
	

func _input(event):
	touching = false
	if event is InputEventScreenTouch:
		if event.is_pressed() and !touching:
			touching = true
			touch_position = event.position
		
	if event is InputEventScreenDrag:
		drag_position = event.position

func touch_screen_movement():
	direction = drag_position - touch_position
	Global.touch_coordinates = str(direction)
	return direction
