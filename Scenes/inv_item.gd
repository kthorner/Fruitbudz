extends TextureButton

var select1 = preload("res://Assets/select_square.png")
var select2 = preload("res://Assets/select_square2.png")
var select3 = preload("res://Assets/select_square3.png")
var hat_sprite = preload("res://Assets/hat_grape.png")
var fertilizer_sprite = preload("res://Assets/fertilizer.png")
var can_sprite = preload("res://Assets/watering_can.png")
var seed_sprite = preload("res://Assets/seed.png")
var selected = false
var in_use = false
var item_type = null
var item_name = ""
var item_desc = ""
var pressdown_position = Vector2()
var press_threshold = 5
onready var inventory = $"/root/Master/World/Inventory"
signal touch(type, name, desc)


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("touch",inventory,"_change_item_selected")

func _gui_input(event):
	if event is InputEventMouseButton and not disabled: 
		if event.pressed:
			pressdown_position = event.position
		elif event.position.distance_to(pressdown_position) <= press_threshold:
			_on_inv_item_pressed()
			
func _set_item(type):
	item_type = type
	if type == "hat":
		$TextureRect.texture = hat_sprite
		item_name = "hat"
		item_desc = "make your pet look great!"
	if type == "fertilizer":
		$TextureRect.texture = fertilizer_sprite
		item_name = "fertilizer"
		item_desc = "provides food when it reaches 0."
	if type == "watering_can":
		$TextureRect.texture = can_sprite
		item_name = "watering can"
		item_desc = "provides water when it reaches 0."
	if type == "seed":
		$TextureRect.texture = seed_sprite
		item_name = "seed"
		item_desc = "grow a new pet!"

func _on_inv_item_pressed():
	if !selected:
		texture_normal = select2
		selected = true
		emit_signal("touch",self, item_name, item_desc)
	else:
		texture_normal = select1
		selected = false
		emit_signal("touch",null, "inventory", "select an item")
		
func _delete_item():
	queue_free()
	
func _gray_out():
	if !in_use:
		$TextureRect.modulate = Color("#707070")
		texture_normal = select3
		in_use = true
	else:
		$TextureRect.modulate = Color("#ffffff")
		texture_normal = select1
		in_use = false
	
func _unselect():
	texture_normal = select1
	selected = false
		
