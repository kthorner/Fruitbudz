extends Node2D

var touched = false
onready var pet_area = $"/root/Master/World/Pet/Area2D"
signal dropped(type)
signal consumed(type,amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("dropped",$"/root/Master/World/GUI","_spawn_consumable")
	self.connect("consumed",$"/root/Master/World/Pet","_change_stat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if touched:
		position = get_global_mouse_position()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			touched = true
			global.dragging = true
		if !event.pressed:
			if is_in_group("water"):
				emit_signal("dropped","water")
			else:
				emit_signal("dropped","food")
			if $Area2D.overlaps_area(pet_area):
				if is_in_group("water"):
					emit_signal("consumed","water",1)
				else:
					emit_signal("consumed","food",1)
			global.dragging = false
			queue_free()
		
func _on_Timer_timeout():
	$Area2D.input_pickable = true
