extends Node

signal start_game

var sound_button = {true : preload("res://assets/images/buttons/audioOn.png"),
					false : preload("res://assets/images/buttons/audioOff.png")}
var music_button = {true : preload("res://assets/images/buttons/musicOn.png"),
					false : preload("res://assets/images/buttons/musicOff.png")}


var current_screen = null

func _ready():
	register_buttons()
	change_screen($TitleScreen)
		
func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])
	
func _on_button_pressed(button):
	if settings.enable_sound:
		$Click.play()
	match button.name:
		"Home":
			change_screen($TitleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("start_game")
		"Settings":
			change_screen($SettingsScreen)
		"Sound":
			settings.enable_sound = !settings.enable_sound
			button.texture_normal = sound_button[settings.enable_sound]
		"Music":
			settings.enable_music = !settings.enable_music
			button.texture_normal = music_button[settings.enable_music]

	
func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = new_screen
	if new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")

func game_over():
	change_screen($GameOvereScreen)
