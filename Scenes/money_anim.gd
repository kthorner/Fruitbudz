extends Node2D

signal money

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("money",$"/root/Master","_change_money")
	
func _set_amount(var amount):
	$CenterContainer/coins.text = "+" + str(amount)
	if amount > 0:
		$Particles2D.set_emitting(true)
		emit_signal("money",amount)
	self.show()

