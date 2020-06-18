extends Control

onready var food_stat = $Information/CenterContainer2/VBoxContainer/Meters/Column2/food_value
onready var water_stat = $Information/CenterContainer2/VBoxContainer/Meters/Column2/water_value
onready var sun_stat = $Information/CenterContainer2/VBoxContainer/Meters/Column2/sun_value
onready var health_stat = $Information/CenterContainer2/VBoxContainer/Meters2/Column2/health_value
onready var happy_stat = $Information/CenterContainer2/VBoxContainer/Meters2/Column2/happy_value
onready var sweet_stat = $Information/CenterContainer2/VBoxContainer/Meters2/Column2/sweet_value
var tab_on = preload("res://Assets/stat_tab1.png")
var tab_off = preload("res://Assets/stat_tab2.png")
var current_tab = 1

func _ready():
	_update_meter("food",5)
	_update_meter("water",5)
	_update_meter("sun",5)
	_update_meter("health",5)
	_update_meter("happy",5)
	_update_meter("sweet",5)

func _update_meter(type,num):
	if type == "food":
		food_stat.text = str(num)
	if type == "water":
		water_stat.text = str(num)
	if type == "sun":
		sun_stat.text = str(num)
	if type == "health":
		health_stat.text = str(num)
	if type == "happy":
		happy_stat.text = str(num)
	if type == "sweet":
		sweet_stat.text = str(num)

func _on_close_pressed():
	self.hide()

func _on_tab1_pressed():
	if current_tab == 2:
		current_tab = 1
		$tab1.texture_normal = tab_on
		$tab2.texture_normal = tab_off
		$Information.show()
		$Information2.hide()

func _on_tab2_pressed():
	if current_tab == 1:
		current_tab = 2
		$tab2.texture_normal = tab_on
		$tab1.texture_normal = tab_off
		$Information.hide()
		$Information2.show()
