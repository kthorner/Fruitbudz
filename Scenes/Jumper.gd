extends Node2D

onready var leaf = $Leaf
var touched = false
var score = 0
var spawns = [20, 50, 90, 140, 200]
var next_bud = 0
var bud_scene = preload("res://Scenes/bounce_bud.tscn")
signal game_select

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("game_select",$"/root/Master","_change_scene")
	print(leaf)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if touched:
		leaf.position = Vector2(get_global_mouse_position().x,clamp(get_global_mouse_position().y,5,50) - 6)
	
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			touched = true
		if !event.pressed:
			touched = false

func _on_Area2D_mouse_exited():
	touched = false
	
func _update_score():
	score += 1
	$Score.text = str(score)
	if score == spawns[next_bud]:
		next_bud += 1
		var bud = bud_scene.instance()
		$Buds.add_child(bud)
		bud.set_global_position(Vector2(rand_range(-15,15),-60))

func _on_Area2D_body_entered(body):
	body.queue_free()
	_game_over()
	
func _game_over():
	$Menu.show()

func _on_detect_area_body_entered(body):
	_update_score()
	body.apply_central_impulse(Vector2(rand_range(-5,5),-15))

func _on_play_pressed():
	emit_signal("game_select","jumper")
	queue_free()


func _on_return_pressed():
	emit_signal("game_select","world")
	queue_free()
