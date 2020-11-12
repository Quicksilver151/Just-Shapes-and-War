extends KinematicBody2D

var direction = Vector2.ZERO
var current_direction = Vector2.ZERO

var touch_position = Vector2.ZERO
var current_finger_position = Vector2.ZERO
var drag_position = Vector2.ZERO
var touching = false

var dashing = false
var cooldown = false

export(float,0,1000,0.1) var speed = 350
export(float,0,1000,0.1) var friction = 15

export(PackedScene) var boost_particle:PackedScene

func _process(delta):
	var dir1 = topdown_movement(speed,delta)
	var dir2 = touch_screen_movement()
	if dir1:
		current_direction = move_and_slide(dir1)/speed
	else:
		move_and_slide(dir2)
	
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


var x = 0
var y = 0

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
	return direction
	

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
			drag_position = event.position
			current_finger_position.x = round(drag_position.x)
			current_finger_position.y = round(drag_position.y)
		Global.touch_coordinates = str(Vector2(event.position.x.round(),event.position.y.round()))
	if event is InputEventScreenDrag:
		touching = true
		drag_position = event.position
		current_finger_position.x = round(drag_position.x)
		current_finger_position.y = round(drag_position.y)

func touch_screen_movement():
	var variable_speed = speed
	
	if touching:
		direction = drag_position - touch_position
		if direction.length() < 10:
			direction = Vector2.ZERO
		elif direction.length() < 128:
			variable_speed = lerp(0,speed,direction.length()/128)
	else:
		direction = Vector2.ZERO
	Global.touch_coordinates = str(current_finger_position)
	return direction.normalized() * variable_speed
