extends Node2D

onready var anim_player = $AnimationPlayer
onready var player = get_parent().get_parent().get_node("Player")
var side_sprite = preload("res://Assets/ninja.png")
var back_sprite = preload("res://Assets/ninja2.png")
var front_sprite = preload("res://Assets/ninja3.png")
var vect = Vector2(0,0)
var can_move = false
var speed = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("smoke_appear")
	
func _process(delta):
	if can_move:
		_set_vect()
		position += vect * speed * delta
		
func _set_direction(side):
	if side == 1:
		$Sprite.texture = side_sprite
	elif side == 2:
		$Sprite.texture = side_sprite
		scale.x = -1.0
	elif side == 3:
		$Sprite.texture = front_sprite
	else:
		$Sprite.texture = back_sprite
		
func _change_texture():
	scale.x = 1.0
	if abs(vect.x) >= abs(vect.y):
		$Sprite.texture = side_sprite
		if vect.x < 0:
			scale.x = -1.0
	else:
		if vect.y < 0:
			$Sprite.texture = back_sprite
		else:
			$Sprite.texture = front_sprite

func _on_move_timer_timeout():
	can_move = false
	anim_player.play("smoke_disappear")

func _set_vect():
	vect = (player.position - position).normalized()
	_change_texture()
		
func _stop_move():
	can_move = false
	$move_timer.stop()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "smoke_appear":
		can_move = true
		$Area2D.monitorable = true
		$move_timer.start(3)
	else:
		queue_free()

func _on_Area2D_area_entered(area):
	$move_timer.stop()
	_on_move_timer_timeout()
