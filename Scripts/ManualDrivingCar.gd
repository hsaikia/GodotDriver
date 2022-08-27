extends KinematicBody

var velocity = Vector3.ZERO
var engine_power = 60
var friction = -2.0
var drag = -0.01
var steer_speed = 1.5 
var steer_direction = 0
var acceleration = Vector3.ZERO

func _physics_process(delta):
	acceleration = Vector3.ZERO
	get_input()
	calculate_streeing(delta)
	apply_drag_and_friction()
	velocity += acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	if velocity.length() < 1.0 and $Throttle.playing == true:
		$Throttle.stop()
	if velocity.length() > 0 and $Throttle.playing == false:
		$Throttle.play()

func calculate_streeing(delta):
	rotate_y(steer_direction * delta)

func apply_drag_and_friction():
	if velocity.length() < 0.1:
		velocity = Vector3.ZERO
	var force_friction = velocity * friction
	var force_drag = velocity * velocity.length() * drag
	acceleration += force_drag + force_friction

func get_input():
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.basis.z * engine_power
	var turn = 0
	if Input.is_action_pressed("steer_left"):
		turn += 1
		$Skid.play()
	if Input.is_action_pressed("steer_right"):
		turn -= 1
		$Skid.play()
	steer_direction = turn * steer_speed
