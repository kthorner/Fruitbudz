extends Node2D

onready var tiles = $TileMap
onready var player = $Player
onready var score_label = $Score/Label
var fruit = 3
var score = 0
var tile_num = 2
signal game_select

func _ready():
	self.connect("game_select",$"/root/Master","_change_scene")

#func _process(delta):
#	pass
	
func _update_fruit():
	fruit -= 1
	tiles.set_cellv(Vector2(0,-1),tile_num)
	tile_num += 1
	if fruit == 0:
		_game_over()
		
func _update_score():
	score += 1
	score_label.text = str(score)
	
func _game_over():
	get_tree().call_group("cells", "_frozen")
	$Menu.show()

func _on_play_pressed():
	emit_signal("game_select","farmer")
	queue_free()

func _on_return_pressed():
	emit_signal("game_select","world")
	queue_free()
