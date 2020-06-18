extends Control

var selected_item = null
var item_array = []
var item_index = 0
var num_items = 0
var item_scene = preload("res://Scenes/inv_item.tscn")
onready var grid = $ScrollContainer/GridContainer
onready var name_text = $Name/item
onready var desc_text = $Description/description
onready var use_button = $use
onready var inventory = $"/root/Master/World/Inventory"
var useables = ["fertilizer","watering_can"]

# Called when the node enters the scene tree for the first time.
func _ready():
	item_array = grid.get_children()

func _add_item(type):
	var item = item_scene.instance()
	grid.add_child(item)
	item._set_item(type)
	item_array = grid.get_children()
	num_items += 1
	if num_items % 2 != 0 && num_items != 1:
		grid.columns += 1
	
func _remove_item():
	if selected_item != null:
		selected_item._delete_item()
		selected_item = null
		_change_item_selected(null, "inventory", "select an item")
		item_array = grid.get_children()
		num_items -= 1
		if num_items % 2 == 0 && num_items != 0:
			grid.columns -= 1
			$Timer.start()

func _change_item_selected(select, name, desc):
	if selected_item != null:
		selected_item._unselect()
	selected_item = select
	name_text.text = name
	desc_text.text = desc
	if selected_item == null:
		use_button.hide()
	else:
		use_button.show()

func _on_close_pressed():
	self.hide()

func _on_use_pressed():
	if useables.has(selected_item.item_type):
		_remove_item()
	else:
		selected_item._gray_out()

func _on_Timer_timeout():
	self.hide()
	self.show()
