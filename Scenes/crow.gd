extends Node2D


var dir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	position += Vector2(dir,0) * 20 * delta

func _set_dir(direction):
	dir = direction
	if dir == 1:
		scale.x = -1

func _on_Timer_timeout():
	queue_free()


func _on_Area2D_area_entered(area):
	queue_free()
