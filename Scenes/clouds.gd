extends Node2D

onready var clouds = [$cloud1,$cloud2,$cloud3]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for cloud in clouds:
		cloud.position.x = randi() % 71 - 30
		cloud.position.y = randi() % 21 - 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for cloud in clouds:
		cloud.position += Vector2(-1,0) * 3 * delta
		if cloud.position.x <= -40:
			cloud.position.x = randi() % 51 + 50
			cloud.position.y = randi() % 21 - 10

