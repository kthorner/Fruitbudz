extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $Sprite
onready var timer = $Timer
var mole = preload("res://Assets/mole.png")
var mole_hit = preload("res://Assets/mole2.png")
var mole_steal = preload("res://Assets/mole3.png")
var state = "hidden"
var wait_time = 7.0
var speed = 2.0
var rng = RandomNumberGenerator.new()
signal fruit_lost
signal hit_mole



# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	self.connect("fruit_lost",self.owner,"_update_fruit")
	self.connect("hit_mole",self.owner,"_update_score")
	timer.start(rng.randf_range(1.2, wait_time))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _frozen():
	timer.stop()
	state = "frozen"

func _on_Timer_timeout():
	if state == "hidden":
		sprite.set_texture(mole)
		state = "pop"
		timer.start(speed)
		speed -= 0.1
		if speed < 0.8:
			speed = 0.8
	elif state == "pop":
		sprite.set_texture(mole_steal)
		state = "steal"
		emit_signal("fruit_lost")
		timer.start(1.0)
	else:
		sprite.set_texture(null)
		state = "hidden"
		timer.start(rng.randf_range(1.5, wait_time))
		wait_time -= 0.2
		if wait_time < 2.0:
			wait_time = 2.0

func _on_button_pressed():
	if state == "pop":
		timer.stop()
		sprite.set_texture(mole_hit)
		state = "hit"
		emit_signal("hit_mole")
		timer.start(0.8)
