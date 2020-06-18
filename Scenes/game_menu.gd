extends Control

signal open_game

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("open_game",$"/root/Master","_change_scene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_finder_pressed():
	self.hide()
	emit_signal("open_game","finder","world")

func _on_sorter_pressed():
	self.hide()
	emit_signal("open_game","sorter","world")

func _on_dodger_pressed():
	self.hide()
	emit_signal("open_game","dodger","world")
	
func _on_farmer_pressed():
	self.hide()
	emit_signal("open_game","farmer","world")
	
func _on_jumper_pressed():
	self.hide()
	emit_signal("open_game","jumper","world")
	
func _on_thrower_pressed():
	self.hide()
	emit_signal("open_game","thrower","world")
	
func _on_runner_pressed():
	self.hide()
	emit_signal("open_game","runner","world")

func _on_close_pressed():
	self.hide()
