extends Spatial

onready var viz = $Viz
onready var curve = $TrackPath/ProceduralPath.curve
onready var total_length = curve.get_baked_length()

func _ready():
	generate_new()

func _process(_delta):
	if Input.is_action_just_released("regenerate"):
		generate_new()
	
	var offset = curve.get_closest_offset($Car.transform.origin)
	var point_1 = curve.interpolate_baked( offset, true )
	var point_2 = curve.interpolate_baked( offset + 0.01, true )
	var track_direction : Vector3 = ( point_2 - point_1 ).normalized()
	var car_direction : Vector3 = $Car.transform.basis.z
	var alignment = track_direction.dot(car_direction)
	#print("Score : ", offset, "/", total_length)
	if alignment < 0 :
		generate_new()
	
	viz.sensor_readings = $Car.sensor_readings
	var formatted_label = "Acceleration {acc}\nSteering {steer}"
	var label = formatted_label.format({"acc": $Car.acceleration.length(), "steer":$Car.steer_direction})
	$Label.set_text(label)
	viz.update()

func generate_new():
	$TrackPath.regenerate()
	$Car.transform.origin = Vector3($TrackPath.start_pos.x, $Car.transform.origin.y, $TrackPath.start_pos.z)
	$TrackPath.next_pos.y =  $Car.transform.origin.y
	$Car.transform = $Car.transform.looking_at($TrackPath.next_pos, Vector3.UP)
