extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vect = Vector2(0,0)
var speed = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	position += vect.normalized() * speed * delta
		
func _set_direction(side):
	if side == 1:
		vect = Vector2(1,0)
		rotation_degrees = 0
	elif side == 2:
		vect = Vector2(-1,0)
		rotation_degrees = 180
	elif side == 3:
		vect = Vector2(0,1)
		rotation_degrees = 90
	else:
		vect = Vector2(0,-1)
		rotation_degrees = 270

func _on_Timer_timeout():
	queue_free()
