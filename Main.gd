extends Node

var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")

var player

func _ready():
	randomize()
	new_game()

#The new_game() function initializes the game
func new_game():
	$Camera2D.position = $StratPosition.position
	player = Jumper.instance()
	player.position = $StratPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	spawn_circle($StratPosition.position)

#spawning a player and a circle at the start position, 
#and setting the camera.
func spawn_circle(_position = null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, 400)
		c.position = player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position)

func _on_Jumper_captured(object):
	$Camera2D.position = object.position
	call_deferred("spawn_circle")
	


