extends Node2D

var new_throw = true
var direction = Vector2(0,0)
var speed_init = 0
var speed = 0
var dampen = 18
onready var tween = $Tween

func _ready():
	pass 

func _process(delta):
	if new_throw == false:
		position += Vector2(direction.x * speed_init, direction.y * speed) * delta
		speed -= 1
		if speed <= 0 && speed >= -1:
			$Area2D.monitorable = true
			
func _get_swipe(dir, vel):
	if new_throw:
		direction = dir
		speed = vel / dampen
		speed_init = speed
		new_throw = false
		tween.interpolate_property($Sprite, "scale", 
		Vector2(1,1), Vector2(0.5,0.5), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		$Timer.start()


func _on_Timer_timeout():
	queue_free()
