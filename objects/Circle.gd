extends Area2D



onready var orbit_position = $Pivot/OrbitPosition

enum MODES {STATIC, LIMITED}

var mode = MODES.STATIC
var num_orbits = 3 # Number of orbits until the circle disap
var current_orbits = 0  # Number of orbits the jumper has completed
var orbit_start = null  # Where the orbits started
var jumper = null



var radius = 100

var rotation_speed = PI


func init(_position, _radius=radius, _mode=MODES.LIMITED):
	set_mode(_mode)
	position = _position	
	radius = _radius
	$Sprite.material = $Sprite.material.duplicate()
	$SpriteEffect.material =  $Sprite.material
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)
	
	

func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	if mode == MODES.LIMITED and jumper:
		check_orbit()
		update()

func check_orbit():# Check if the jumper completed a full circle
	if abs( $Pivot.rotation - orbit_start) > 2 * PI:
		current_orbits -= 1
		if settings.enable_sound:
			$Beep.play()
		$Label.text = str(current_orbits)
		if current_orbits <= 0:
			jumper.die()
			jumper = null
			implode()
		orbit_start = $Pivot.rotation



func implode():
	$AnimationPlayer.play("Implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func capture(target):
	jumper = target
	$AnimationPlayer.play("Capture")
	$Pivot.rotation = (jumper.position - position).angle()
	orbit_start = $Pivot.rotation
	

func _draw():
	if jumper:
		var r = ((radius - 50 ) / num_orbits) * (1 + num_orbits - current_orbits)
		draw_circle_arc_poly(Vector2.ZERO, r, orbit_start + PI/2,
							$Pivot.rotation + PI/2, settings.theme["circle_fill"])

func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		MODES.STATIC:
			$Label.hide()
			color = settings.theme["circle_static"]
		MODES.LIMITED:
			$Label.text = str(current_orbits)
			color = settings.theme["circle_limited"]
			$Label.show()
	$Sprite.material.set_shader_param("color", color)

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
