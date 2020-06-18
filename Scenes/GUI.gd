extends Control

var food_scene = preload("res://Scenes/food.tscn")
var water_scene = preload("res://Scenes/water.tscn")
var food_ref
var water_ref
var show_care = false
onready var world = $"/root/Master/World"
onready var stats = $"/root/Master/World/Stats"
onready var games = $"/root/Master/World/Game Menu"
onready var inventory = $"/root/Master/World/Inventory"
onready var main_menu = $"/root/Master/World/main_menu"
onready var pet = $"/root/Master/World/Pet"
signal open_shop
signal pp(type, amount)

func _ready():
	self.connect("open_shop",$"/root/Master","_change_scene")
	self.connect("pp",pet,"_change_stat")
		
func _spawn_consumable(type):
	var new 
	if type == "water":
		new = water_scene.instance()
		water_ref = new
		world.add_child(new)
		new.set_global_position(Vector2(-6,43))
	if type == "food":
		new = food_scene.instance()
		food_ref = new
		world.add_child(new)
		new.set_global_position(Vector2(-15,43))

func _on_Stats_pressed():	
	if !stats.is_visible():
		stats.show()
		games.hide()
		inventory.hide()
		main_menu.hide()
	else:
		stats.hide()

func _on_Games_pressed():
	if !games.is_visible():
		games.show()
		stats.hide()
		inventory.hide()
		main_menu.hide()
	else:
		games.hide()
		
func _on_Inventory_pressed():
	if !inventory.is_visible():
		inventory.show()
		stats.hide()
		games.hide()
		main_menu.hide()
	else:
		inventory.hide()

func _on_Arrow_pressed():
	if show_care:
		$main.show()
		$care.hide()
		water_ref.queue_free()
		food_ref.queue_free()
		show_care = false
	else:
		$main.hide()
		$care.show()
		_spawn_consumable("food")
		_spawn_consumable("water")
		show_care = true

func _on_Shop_pressed():
	inventory.hide()
	stats.hide()
	games.hide()
	main_menu.hide()
	emit_signal("open_shop","shop","world")


func _on_Praise_pressed():
	if pet.can_respond:
		print("Praise")
		pet.can_respond = false
		emit_signal("pp","sweet", 1)
	else:
		emit_signal("pp","sweet", -1)

func _on_Punish_pressed():
	if pet.can_respond:
		print("Punish")
		pet.can_respond = false
		emit_signal("pp","sweet", 1)
	else:
		emit_signal("pp","sweet", -1)
