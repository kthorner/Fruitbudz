extends Node2D

var game_type = "finder"
onready var pet = $pet
var pos_array = [0,0,0]
var anim_array = ["1-2-swap1","1-2-swap2","1-3-swap1","1-3-swap2","2-3-swap1",\
"2-3-swap2","left-shift1","left-shift2","right-shift1","right-shift2"]
var move_array = [[1,0,2],[1,0,2],[2,1,0],[2,1,0],[0,2,1],\
[0,2,1],[2,0,1],[2,0,1],[1,2,0],[1,2,0]]
var counter = 0
var max_moves = 20
var final_pos = 0
var correct = false
signal game_select

func _ready():
	self.connect("game_select",$"/root/Master","_change_scene")
	var pos = randi() % 3
	pos_array[pos] = 1
	if pos == 0:
		pet.position = Vector2(-18,-8)
	elif pos == 1:
		pet.position = Vector2(0,-8)
	else:
		pet.position = Vector2(18,-8)
	$AnimationPlayer.play("pet_hide")
	$start_timer.start()
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		$Menu._open_leave()

func _on_shuffle_timer_timeout():
	if counter < max_moves:
		var num = randi() % 10
		$AnimationPlayer.play(anim_array[num])
		var new_array = [0,0,0]
		var index = pos_array.find(1)
		var new_pos = move_array[num][index]
		new_array[new_pos] = 1
		pos_array = new_array
		counter += 1
	else:
		$shuffle_timer.stop()
		final_pos = pos_array.find(1)
		if final_pos == 0:
			pet.position = Vector2(-18,-8)
		elif final_pos == 1:
			pet.position = Vector2(0,-8)
		else:
			pet.position = Vector2(18,-8)
		$area1.input_pickable = true
		$area2.input_pickable = true
		$area3.input_pickable = true

func _on_start_timer_timeout():
	$shuffle_timer.start()
	$AnimationPlayer.playback_speed = 4
	$shuffle_timer.wait_time = 0.4
	

func _on_end_timer_timeout():
	$Menu._open_end()

func _on_area1_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed:
		if final_pos == 0:
			correct = true
		_game_end()


func _on_area2_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed:
		if final_pos == 1:
			correct = true
		_game_end()


func _on_area3_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.pressed:
		if final_pos == 2:
			correct = true
		_game_end()

func _game_end():
	$end_timer.start()
	$AnimationPlayer.play("pet_show")
	if correct:
		$money_anim._set_amount(5)
	else:
		$money_anim._set_amount(0)
	$area1.input_pickable = false
	$area2.input_pickable = false
	$area3.input_pickable = false
