extends KinematicBody

var velocity = Vector3.ZERO
var engine_power = 60
var friction = -1.0
var drag = -0.01
var steer_speed = 1.0 
var steer_direction = 0
var acceleration = Vector3.ZERO
var num_sensors = 11
var sensor_range_min = -5 * PI / 12
var sensor_range_max = 5 * PI / 12
var ray_length = 100
var sensor_readings = []

func update_lidar_status():
	sensor_readings = []
	var space_state = get_world().direct_space_state
	var sensor_range = sensor_range_max - sensor_range_min
	var sensor_sum = 0
	var num_readings = 0
	for idx in range(0, num_sensors):
		var angle = idx * sensor_range / (num_sensors - 1) + sensor_range_min
		var origin = transform.origin
		origin.y = 0.5
		var direction = transform.basis.z.rotated(Vector3.UP, angle)
		var result = space_state.intersect_ray(origin, origin + ray_length * direction)
		if result :
			var dist = (result.position - transform.origin).length()
			sensor_readings.append([dist, angle])
			sensor_sum += dist * angle
			num_readings += 1
	if num_readings > 0 :
		sensor_sum /= num_readings
	steer_direction = steer_speed * sensor_sum
	acceleration = transform.basis.z * engine_power / (1.0 + pow(abs(steer_direction), 2))
	#print(sensor_sum)

func _physics_process(delta):
	#acceleration = Vector3.ZERO
	#acceleration = transform.basis.z * engine_power
	#get_input()
	calculate_steering(delta)
	apply_drag_and_friction()
	velocity += acceleration * delta
	velocity.y = 0
	velocity = move_and_slide(velocity, Vector3.UP)
	update_lidar_status()
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print(collision.position)
#		print("Collided with: ", collision.collider.name)

func calculate_steering(delta):
	rotate_y(steer_direction * delta)

func apply_drag_and_friction():
	if velocity.length() < 0.1:
		velocity = Vector3.ZERO
	var force_friction = velocity * friction
	var force_drag = velocity * velocity.length() * drag
	acceleration += force_drag + force_friction

#func get_input_auto():
#	var acc = transform.basis.z
#	print("Good ", good_direction)
#	acc = acc.linear_interpolate(good_direction, steer_speed)
#	steer_direction = transform.basis.z.angle_to(acceleration)
#	if steer_direction > 0 :
#		print(steer_direction, " Turn left")
#	else :
#		print(steer_direction, " Turn Right")
	#move_and_collide(velocity * delta)

func get_input():
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.basis.z * engine_power
	var turn = 0
	if Input.is_action_pressed("steer_left"):
		turn += 1
	if Input.is_action_pressed("steer_right"):
		turn -= 1
#	if Input.is_action_just_released("sensor_status"):
#		get_input_auto()
	steer_direction = turn * steer_speed


func _on_HSlider_value_changed(value):
	engine_power = value
