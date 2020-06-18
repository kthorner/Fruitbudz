extends Node2D

enum move_states {STOP,GOTO,WANDER}
var move_state = move_states.STOP
onready var sunmoon = $"/root/Master/World/Sun_Moon"
onready var exclamation = $"/root/Master/World/exclamation"
onready var body_anim = $"Body Animations"
onready var face_anim = $"Face Animations"
onready var eyes_sprite = $"Face/Eyes Sprite"
onready var mouth_sprite = $"Face/Mouth Sprite"
var pet_name = "Vinny"
var pet_age = 0
var time_elapsed = 0
var food = 5
var water = 5
var sun = 5
var health = 5
var happy = 5
var sweet = 5
var water_wait = 10
var food_wait = 15
var target = Vector2(0,0)
var in_action = false
var behavior = ""
var facing = "left"
var petted = false
var min_pos = Vector2(-16,26)
var max_pos = Vector2(16,-18)
onready var behave_timer = $"Timers/Behavior Timer"
var behavior_queued = ""
var can_respond = false
signal meter (type,amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	body_anim.play("idle")
	self.connect("meter",$"/root/Master/World/Stats","_update_meter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_movement()
	
func _movement():
	if (move_state == move_states.WANDER || move_state == move_states.GOTO) && !in_action:
		if (target - position).length() > 1:
			position += (target - position).normalized() * 10 * get_process_delta_time()
		else:
			move_state = move_states.STOP
			body_anim.play("idle")


func _on_Wander_Timer_timeout():
	target  =  Vector2(randi() % (int(max_pos.x) - int(min_pos.x)) + int(min_pos.x), \
	randi() % (int(min_pos.y) - int(max_pos.y)) + int(max_pos.y))
	if (target - position).length() < 15:
		if move_state == move_states.WANDER:
			move_state = move_states.STOP
			if !in_action:
				body_anim.play("idle")
	else:
		if (target - position).x <= 0:
			facing = "left"
		else:
			facing = "right"
		if move_state == move_states.STOP:
			move_state = move_states.WANDER
			if !in_action:
				body_anim.play("walk")
			
func _change_stat(stat, amount):
	if stat == "food":
		food = clamp(food + amount,0,11)
		if amount > 0:
			_start_eat_anim()
		if food == 11 or food == 0:
			_change_stat("health",-1)
		emit_signal("meter",stat,food)
	elif stat == "water":
		water = clamp(water + amount,0,11)
		if amount > 0:
			_start_drink_anim()
		if water == 11 or water == 0:
			_change_stat("health",-1)
		emit_signal("meter",stat,water)
	elif stat == "sun":
		sun = clamp(sun + amount,0,11)
		if sun == 11 or sun == 0:
			_change_stat("health",-1)
		emit_signal("meter",stat,sun)
	elif stat == "health":
		health = clamp(health + amount,0,10)
		emit_signal("meter",stat,health)
	elif stat == "happy":
		happy = clamp(happy+ amount,0,10)
		emit_signal("meter",stat,happy)
	elif stat == "sweet":
		sweet = clamp(sweet + amount,0,10)
		emit_signal("meter",stat,sweet)
	_check_warning()
	
func _check_warning():
	if food == 11 or food == 0 or water == 11 or water == 0 or sun == 11 or sun == 0:
		exclamation.show()
	else:
		exclamation.hide()
		
func _set_face():
	if happy >= 3:
		face_anim.play("happy")
	else:
		face_anim.play("sad")

func _on_Body_Animations_animation_started(anim_name):
	#$"Face".position.y = 0
	if facing == "left":
		eyes_sprite.scale.x = 1
		eyes_sprite.position.x = -1
		mouth_sprite.position.x = -1
	else:
		eyes_sprite.scale.x = -1
		eyes_sprite.position.x = 1
		mouth_sprite.position.x = 1
			

func _on_Blink_Timer_timeout():
	if !in_action:
		face_anim.play("blink")
	$"Timers/Blink Timer".start(randi() % 6 + 5)


func _face_anim_finished(anim_name):
	if anim_name == "blink":
		_set_face()
	elif anim_name == "eat" or anim_name == "drink":
		_action_reset()
	elif anim_name == "shake" or anim_name == "wink" or anim_name == "nod":
		can_respond = true
		$"Timers/Response Timer".start()
		_action_reset()
		
func _action_reset():
		in_action = false
		behavior = ""
		_set_face()
		if move_state == move_states.WANDER:
			body_anim.play("walk")
		elif move_state == move_states.STOP:
			body_anim.play("idle")

func _body_anim_finished(anim_name):
	# Only for non-looping animations
	if anim_name == "wave":
		in_action = false
		can_respond = true
		$"Timers/Response Timer".start()
		if move_state == move_states.WANDER:
			body_anim.play("walk")
		elif move_state == move_states.STOP:
			body_anim.play("idle")

func _on_Age_Timer_timeout():
	time_elapsed += 1

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and !in_action:
			in_action = true
			petted = true
			body_anim.play("still2")
			face_anim.play("pleasure")
			_change_stat("happy",1)
		if !event.pressed and petted:
			petted = false
			_action_reset()

func _on_Area2D_mouse_exited():
	if petted:
		petted = false
		_action_reset()
		
func _start_eat_anim():
	_set_face()
	in_action = true
	body_anim.play("still")
	face_anim.play("eat")

func _start_drink_anim():
	_set_face()
	in_action = true
	body_anim.play("still")
	face_anim.play("drink")

func _on_Food_Timer_timeout():
	_change_stat("food",-1)
	$"Timers/Food Timer".set_wait_time(food_wait)
	
func _on_Water_Timer_timeout():
	_change_stat("water",-1)
	$"Timers/Water Timer".set_wait_time(water_wait)
	
func _on_Sun_Timer_timeout():
	if sunmoon.is_day:
		_change_stat("sun",1)
	else:
		_change_stat("sun",-1)

func _on_Health_Timer_timeout():
	if food >= 1 and water >= 1 and sun >= 1:
		if food != 11 and water != 11 and sun != 11:
			_change_stat("health",1)

func _on_Happy_Timer_timeout():
	_change_stat("happy",-1)
	if !in_action:
		_set_face()

func _on_Behavior_Timer_timeout():
	var num = randi() % 4
	if !in_action:
		in_action = true
		if num == 0:
			body_anim.play("still")
			face_anim.play("wink")
			behavior = "wink"
		elif num == 1:
			body_anim.play("wave")
			behavior = "wave"
		elif num == 2:
			body_anim.play("still")
			face_anim.play("shake")
			behavior = "shake"
		elif num == 3:
			body_anim.play("still")
			face_anim.play("nod")
			behavior = "nod"
		#behave_timer.start(randi() % sweet)

func _on_Response_Timer_timeout():
	if can_respond:
		can_respond = false
		_change_stat("sweet",-1)
		
