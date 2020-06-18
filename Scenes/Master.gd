extends Node2D

var finder_scene = preload("res://Scenes/Finder.tscn")
var sorter_scene = preload("res://Scenes/Sorter.tscn")
var dodger_scene = preload("res://Scenes/Dodger.tscn")
var farmer_scene = preload("res://Scenes/Farmer.tscn")
var jumper_scene = preload("res://Scenes/Jumper.tscn")
var thrower_scene = preload("res://Scenes/Thrower.tscn")
var runner_scene = preload("res://Scenes/Runner.tscn")
var shop_scene = preload("res://Scenes/Shop.tscn")
onready var world_scene = $World
var current_scene = "world"
var money = 10

func _ready():
	randomize()
	get_tree().set_auto_accept_quit(false)
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if current_scene == "world":
			get_tree().quit()

func _input(event):
	pass
		
func _change_money(amount):
	money += amount
		
func _change_scene(open,close=""):
	if open == "world":
		add_child(world_scene)
	elif open == "shop":
		add_child(shop_scene.instance())
	else:
		if open == "finder":
			add_child(finder_scene.instance())
		elif open == "sorter":
			add_child(sorter_scene.instance())
		elif open == "dodger":
			add_child(dodger_scene.instance())
		elif open == "farmer":
			add_child(farmer_scene.instance())
		elif open == "jumper":
			add_child(jumper_scene.instance())
		elif open == "thrower":
			add_child(thrower_scene.instance())
		elif open == "runner":
			add_child(runner_scene.instance())
	if close == "world":
		remove_child(world_scene)
	current_scene = open
	
