extends Node2D

var is_touched = false
var picked = false
var in_crate = false
var dir = ""
var cherry_sprite = preload("res://Assets/cherry_sort.png")
var apple_sprite = preload("res://Assets/apple_sort.png")
var orange_sprite = preload("res://Assets/orange_sort.png")
onready var sort_game = get_parent().get_parent()
signal moved(fruit)

# Called when the node enters the scene tree for the first time.
func _ready():
	var num = randi() % 3
	if num == 0:
		$Sprite.texture = apple_sprite
		$pos_area.add_to_group("apple")
	if num == 1:		
		$Sprite.texture = cherry_sprite
		$pos_area.add_to_group("cherry")
	if num == 2:
		$Sprite.texture = orange_sprite
		$pos_area.add_to_group("orange")
		
	var face = randi() % 2
	if face == 0:
		self.scale.x = -1
	self.connect("moved",sort_game,"_remove_fruit")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_touched:
		position = get_global_mouse_position()
	if in_crate:
		if dir == "left":
			position += Vector2(-1,0) * 10 * delta
			if position.x <= -75:
				queue_free()
		elif dir == "right":
			position += Vector2(1,0) * 10 * delta
			if position.x >= 75:
				queue_free()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and sort_game.dragging == false:
			is_touched = true
			sort_game.dragging = true
			if !picked:
				picked = true
				emit_signal("moved",self)
			if in_crate:
				in_crate = false
				dir = ""
		if !event.pressed and picked:
			is_touched = false
			sort_game.dragging = false
			var crates = $pos_area.get_overlapping_areas()
			if !crates.empty():
				in_crate = true
				dir = crates[0].get_parent().dir
			else:
				$touch_area.queue_free()
				$pos_area.queue_free()
				$AnimationPlayer.play("drop")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
