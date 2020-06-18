extends Node2D

var elapsed_time = 0    
var start
var start_time
var touched = false
var fruit_spawned = true
var score = 0
var dir = 1

var fruit_scene = preload("res://Scenes/throw_fruit.tscn")
onready var current_fruit = $fruit_node/throw_fruit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	elapsed_time += delta
	$hoop.position.x += 0.08 * dir
	if ($hoop.position.x < -18): 
		dir = 1
	elif ($hoop.position.x > 18):
		dir = -1

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			start = event.position
			start_time = elapsed_time
		else:
			if touched:
				var direction = event.position - start
				var speed = (direction.length())/(elapsed_time - start_time)
				if speed > 200:
					direction = direction.normalized()
					current_fruit._get_swipe(direction, speed)
					touched = false
					fruit_spawned = false
					$spawn_fruit.start()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed() && fruit_spawned:
			touched = true

func _on_spawn_fruit_timeout():
	var new_fruit = fruit_scene.instance()
	$fruit_node.add_child(new_fruit)
	current_fruit = new_fruit
	fruit_spawned = true


func _on_Area2D_area_entered(area):
	$hoop/hoop2.show()
	score += 1
	$Score.text = str(score)
	$hoop_show.start()


func _on_hoop_show_timeout():
	$hoop/hoop2.hide()
