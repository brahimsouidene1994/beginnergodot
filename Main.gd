extends Node

var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")


var player
var score = 0

func _ready():
	randomize()
	$HUD.hide()
	
#The new_game() function initializes the game
func new_game():
	var score = 0
	$HUD.update_score(score)
	$HUD.show()
	$HUD.show_message("Go!")
	$Camera2D.position = $StratPosition.position
	player = Jumper.instance()
	player.position = $StratPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	spawn_circle($StratPosition.position)
	player.connect("died", self, "_on_Jumper_died")
	if settings.enable_music:
		$Music.play()

#spawning a player and a circle at the start position, 
#and setting the camera.
func spawn_circle(_position = null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, 400)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position)
	

func _on_Jumper_captured(object):
	score += 1
	$HUD.update_score(score)
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
	
func _on_Jumper_died():
	$HUD.hide()
	get_tree().call_group("circles", "implode")
	$Screens.game_over()
	if settings.enable_music:
		$Music.stop()

