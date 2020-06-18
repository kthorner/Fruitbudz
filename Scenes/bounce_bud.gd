extends RigidBody2D

onready var timer = $Timer
var bud1 = preload("res://Assets/bud1.png")
var bud2 = preload("res://Assets/bud2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = randi() % 2
	if rand == 0:
		$Sprite.texture = bud1
	else:
		$Sprite.texture = bud2
	
func _integrate_forces(state):
	if state.linear_velocity.length() > 100:
		state.linear_velocity = state.linear_velocity.normalized() * 100
	
