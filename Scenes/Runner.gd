extends Node2D

var fast_speed = 1.2
var slow_speed = 1.0
var speed = fast_speed
var rot_degree = 0.05
var velocity = Vector2(0,0)
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (velocity.x == 1):
		$KinematicBody2D.rotation += rot_degree
	elif (velocity.x == -1):
		$KinematicBody2D.rotation -= rot_degree
	$KinematicBody2D.move_and_collide(Vector2(0,-1).rotated($KinematicBody2D.rotation) * speed)

func _on_left_pressed():
	if pressed == false:
		velocity.x -= 1
		pressed = true
		speed = slow_speed

func _on_left_released():
	velocity.x = 0
	pressed = false
	speed = fast_speed

func _on_right_pressed():
	if pressed == false:
		velocity.x += 1
		pressed = true
		speed = slow_speed

func _on_right_released():
	velocity.x = 0
	pressed = false
	speed = fast_speed

func _on_speed_timer_timeout():
	print("SPEED UP")
	fast_speed += 0.05
	slow_speed += 0.05
	rot_degree += 0.005
	
