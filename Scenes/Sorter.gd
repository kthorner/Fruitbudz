extends Node2D

var game_type = "sorter"
var fruit_scene = preload("res://Scenes/drag_fruit.tscn")
var crate_scene = preload("res://Scenes/crate.tscn")
var pos_array = [Vector2(-17,-38),Vector2(11,-43),Vector2(-2,-15), \
Vector2(21,-22),Vector2(12,-13), Vector2(-15,-17),Vector2(-8,-27),Vector2(2,-34),\
Vector2(9,-25),Vector2(19,-35),Vector2(-21,-27),Vector2(-6,-42)]
var fruit_array = []
# apple, cherry, orange
var dragging = false
var time = 60
var score = 0 
signal game_end

func _ready():
	self.connect("game_end",$"/root/Master","_change_scene")
	$Time.text = str(time)
	_on_Crate_Timer_timeout()
	for pos in pos_array:
		var new_fruit = fruit_scene.instance()
		$YSort.add_child(new_fruit)
		new_fruit.position = pos
		fruit_array.append(new_fruit)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$Menu._open_leave()

func _remove_fruit(fruit):
	var index = fruit_array.find(fruit)
	fruit_array[index] = null	

func _on_Spawn_Timer_timeout():
	if fruit_array.has(null):
		var done = false
		while !done:
			var index = randi() % pos_array.size()
			if fruit_array[index] == null:
				var new_fruit = fruit_scene.instance()
				$YSort.add_child(new_fruit)
				new_fruit.position = pos_array[index]
				fruit_array[index] = new_fruit
				done = true

func _on_Game_Timer_timeout():
	if time > 0:
		time -= 1
		$Time.text = str(time)
	elif time == 0:
		time -= 1
		$"Crate Timer".stop()
	else:
		if $Crates.get_child_count() == 0:
			$"Game Timer".stop()
			_game_over()
		
func _game_over():
	$Menu._open_end()
	$money_anim._set_amount(score/5)
	
func _update_score(points):
	score += points
	if score < 0:
		score = 0
	$Score.text = str(score)

func _on_Crate_Timer_timeout():
	var new_crate_left = crate_scene.instance()
	$Crates.add_child(new_crate_left)
	new_crate_left._set_dir("left")
	new_crate_left.position = Vector2(40,31)
	var new_crate_right = crate_scene.instance()
	$Crates.add_child(new_crate_right)
	new_crate_right._set_dir("right")
	new_crate_right.position = Vector2(-40,11)
	
func _update_dragging(value):
	dragging = value
