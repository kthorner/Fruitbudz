extends Node2D

onready var player = $Player
onready var face = $"Player/Face"
onready var eyes = $"Player/Face/Eyes Sprite"
onready var mouth = $"Player/Face/Mouth Sprite"
onready var anim_player = $Player/AnimationPlayer
onready var time_label = $CanvasLayer/Time
var facing = "right"
var moving = true
var game_over = false
var time = 0
var coins = 0
var coins_spawned = 0
var player_speed = 80
var ninja_scene = preload("res://Scenes/ninja.tscn")
var shuriken_scene = preload("res://Scenes/shuriken.tscn")
var kunai_scene = preload("res://Scenes/kunai.tscn")
var coin_scene = preload("res://Scenes/coin.tscn")
var rng = RandomNumberGenerator.new()
var velocity = Vector2(0,0)
var analog_velocity = Vector2(0,0)
signal game_select

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	self.connect("game_select",$"/root/Master","_change_scene")
	_on_coin_timer_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2(0,0)
	velocity += analog_velocity	
	if velocity.length() > 0:
		if !moving:
			moving = true
			anim_player.play("walk")
		player.position += velocity.normalized() * player_speed * delta
		player.position.x = clamp(player.position.x, -96, 96)
		player.position.y = clamp(player.position.y, -96, 96)
		if velocity.x < 0 and facing == "right":
			facing = "left"
			_change_face()
		elif velocity.x >=0 and facing == "left":
			facing = "right"
			_change_face()
	else:
		if moving:
			moving = false
			anim_player.play("idle")
		
func _change_face():
	if facing == "left":
		face.scale.x = -1
	else:
		face.scale.x = 1

func _on_Area2D_area_entered(area):
	if game_over == false:
		if area.is_in_group("coin"):
			coins += 1
			coins_spawned -= 1
			time_label.text = str(coins)
			area.get_parent().queue_free()
		else:
			game_over = true
			$CanvasLayer/Menu.show()
			var timers = $Timers.get_children()
			for timer in timers:
				timer.stop()

func _on_game_timer_timeout():
	time += 0.1
	time_label.text = str(time)

func _on_shuriken_timer_timeout():
	var shuriken = shuriken_scene.instance()
	var rand_x = rng.randi_range(-150, 150)
	var rand_y = rng.randi_range(-150, 150)
	var side = rng.randi_range(1, 4)
	if side == 1:
		rand_x = -150
	elif side == 2:
		rand_x = 150
	elif side == 3:
		rand_y = -150
	else:
		rand_y = 150
	shuriken.set_global_position(Vector2(rand_x,rand_y))
	shuriken._set_vect(player.position)
	$Shurikens.add_child(shuriken)

func _on_ninja_timer_timeout():
	var ninja = ninja_scene.instance()
	var rand_x = rng.randi_range(-92, 92)
	var rand_y = rng.randi_range(-96, 90)
	var side = rng.randi_range(1, 4)
	if side == 1:
		rand_x = -92
	elif side == 2:
		rand_x = 92
	elif side == 3:
		rand_y = -96
	else:
		rand_y = 90
	ninja.set_global_position(Vector2(rand_x, rand_y))
	ninja._set_direction(side)
	$Ninjas.add_child(ninja)


func _on_coin_timer_timeout():
	if coins_spawned < 3:
		var coin = coin_scene.instance()
		var rand_x = rng.randi_range(-96, 96)
		var rand_y = rng.randi_range(-96, 96)
		coin.set_global_position(Vector2(rand_x, rand_y))
		coins_spawned += 1
		$Coins.add_child(coin)

func _on_kunai_timer_timeout():
	var kunai = kunai_scene.instance()
	var rand_x = rng.randi_range(-96, 96)
	var rand_y = rng.randi_range(-96, 96)
	var side = rng.randi_range(1, 4)
	if side == 1:
		rand_x = -150
	elif side == 2:
		rand_x = 150
	elif side == 3:
		rand_y = -150
	else:
		rand_y = 150
	kunai.set_global_position(Vector2(rand_x,rand_y))
	kunai._set_direction(side)
	$Kunais.add_child(kunai)
	
func analog_force_change(inForce):
	if (inForce.length() < 0.1):
		analog_velocity = Vector2(0,0) 
	else:
		analog_velocity = Vector2(inForce.x,-inForce.y)
	analog_velocity = analog_velocity.normalized()
	#analog_velocity.x = stepify(analog_velocity.x, 1)
	#analog_velocity.y = stepify(analog_velocity.y, 1)


func _on_return_button_pressed():
	emit_signal("game_select","world")
	queue_free()


func _on_play_button_pressed():
	emit_signal("game_select","dodger")
	queue_free()
