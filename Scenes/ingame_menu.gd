extends Control

signal game_select

func _ready():
	self.connect("game_select",$"/root/Master","_change_scene")
	
func _open_leave():
	if !self.is_visible():
		$Leave.show()
		self.show()
	
func _open_end():
	$Leave.hide()
	$End.show()
	self.show()

func _on_play_pressed():
	emit_signal("game_select", get_parent().game_type)
	get_parent().queue_free()

func _on_return_pressed():
	emit_signal("game_select","world")
	get_parent().queue_free()

func _on_no_pressed():
	$Leave.hide()
	self.hide()
