extends Node2D

onready var dark = $"/root/Master/World/darkness"
onready var sky = $"/root/Master/World/sky"
var moon_sprite = preload("res://Assets/moon.png")
var sun_sprite = preload("res://Assets/sun.png")
var is_day = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed:
		if is_day:
			dark.show()
			sky.modulate = Color(0.03,0.04,0.16,1)
			$Sprite.texture = moon_sprite
			is_day = false
		else:
			$Sprite.texture = sun_sprite
			sky.modulate = Color(0.23,0.73,1,1)
			dark.hide()
			is_day = true
