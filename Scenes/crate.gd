extends Node2D

var dir = ""
var fruit_type
signal score
var cherry_crate = preload("res://Assets/crate_cherry.png")
var apple_crate = preload("res://Assets/crate_apple.png")
var orange_crate = preload("res://Assets/crate_orange.png")
onready var sort_game = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("score",sort_game,"_update_score")
	fruit_type = randi() % 3
	if fruit_type == 0:
		$Crate.texture = apple_crate
	elif fruit_type == 1:
		$Crate.texture = cherry_crate
	else:
		$Crate.texture = orange_crate

func _process(delta):
	if dir == "left":
		position += Vector2(-1,0) * 10 * delta
		if position.x <= -40:
			_check_crate()
	elif dir == "right":
		position += Vector2(1,0) * 10 * delta
		if position.x >= 40:
			_check_crate()

func _check_crate():
	var fruits = $Area2D.get_overlapping_areas()
	var totals = [0,0,0]
	for fruit in fruits:
		if fruit.is_in_group("apple"):
			totals[0] += 1
		if fruit.is_in_group("cherry"):
			totals[1] += 1
		if fruit.is_in_group("orange"):
			totals[2] += 1
	if totals[fruit_type] > 0:
		var points = totals[fruit_type]
		totals[fruit_type] = 0
		if totals.max() == 0:
			emit_signal("score",points)
		else:
			emit_signal("score",-3)
	else:
		emit_signal("score",-3)
	queue_free()

func _set_dir(direction):
	dir = direction
