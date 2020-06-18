extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 0
var vect = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = (randi() % 20) + 30

func _set_vect(target):
	vect = (target - position).normalized()

func _process(delta):
	position += vect * speed * delta

func _on_Timer_timeout():
	queue_free()

func _on_Spin_Timer_timeout():
	$Sprite.rotation += 12
