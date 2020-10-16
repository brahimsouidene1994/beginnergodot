extends Area2D

signal captured

var velocity = Vector2(100, 0)  # start value for testing
var jump_speed = 1000
var target = null  # if we're on a circle

#detect the screen touch and, if we’re on a circle, call our jump
func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()

#Jumping means leaving a circle and traveling forward at our jump speed
func jump():
	target = null
	velocity = transform.x * jump_speed



func _on_Jumper_area_entered(area):
	target = area
	velocity = Vector2.ZERO
	emit_signal("captured", area)
	

func _physics_process(delta):
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
