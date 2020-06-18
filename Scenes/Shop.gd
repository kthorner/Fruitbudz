extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal close_shop
var wares = ["hat","fertilizer","watering_can","seed"]
var prices = [5, 1, 2, 500]
var wares_sprites = []
var pos = 0
var hat_sprite = preload("res://Assets/hat_grape.png")
var fertilizer_sprite = preload("res://Assets/fertilizer.png")
var can_sprite = preload("res://Assets/watering_can.png")
var seed_sprite = preload("res://Assets/seed.png")
onready var Master = $"/root/Master"
onready var money_text = $CenterContainer/HBoxContainer/Money
onready var cost_text = $cost
signal money(amount)
signal buy(item)
onready var desc = $Description/Label
var letters = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("close_shop",$"/root/Master","_change_scene")
	self.connect("money",$"/root/Master","_change_money")
	self.connect("buy",$"/root/Master/World/Inventory","_add_item")
	wares_sprites = [hat_sprite,fertilizer_sprite,can_sprite,seed_sprite]
	$Shopkeeper/AnimationPlayer.play("idle")
	money_text.text = str(Master.money)
	cost_text.text = "cost: " + str(prices[pos])

#func _process(delta):
#	pass

func _on_back_pressed():
	emit_signal("close_shop","world")
	queue_free()


func _on_left_button_pressed():
	pos -= 1
	if pos < 0:
		pos = wares.size() - 1
	$current_item.texture = wares_sprites[pos]
	cost_text.text = "cost: " + str(prices[pos])
	desc.text = "TEST"
	_reset_print()

func _on_right_button_pressed():
	pos += 1
	if pos > (wares.size() - 1):
		pos = 0
	$current_item.texture = wares_sprites[pos]
	cost_text.text = "cost: " + str(prices[pos])
	desc.text = "TEST"
	_reset_print()

func _on_buy_pressed():
	if (Master.money >= prices[pos]):
		emit_signal("money",prices[pos] * -1)
		emit_signal("buy",wares[pos])
		money_text.text = str(Master.money)
		$response.show()
		$response_timer.start()

func _on_response_timer_timeout():
	$response.hide()


func _on_print_timer_timeout():
	letters += 1
	desc.visible_characters = letters
	if letters > 130:
		$print_timer.stop()
		
func _reset_print():
	letters = 0
	desc.visible_characters = letters
	$print_timer.start()
	
