extends Node2D

var touched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if touched:
		position = Vector2(clamp(get_global_mouse_position().x,-20,20),-38)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			touched = true
		if !event.pressed:
			touched = false
			
func _on_Area2D_mouse_exited():
	touched = false

func _on_Area2D_area_entered(area):
	pass

func _on_Area2D_area_exited(area):
	pass
