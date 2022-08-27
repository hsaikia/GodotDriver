extends Spatial

func _ready():
	$TrackPath.regenerate()
	set_car()

func _process(_delta):
	if Input.is_action_just_released("regenerate"):
		$TrackPath.regenerate()
		set_car()
	self_drive()

func set_car():
	$Car.transform.origin = Vector3($TrackPath.start_pos.x, $Car.transform.origin.y, $TrackPath.start_pos.z)
	$TrackPath.next_pos.y =  $Car.transform.origin.y
	$Car.transform = $Car.transform.looking_at($TrackPath.next_pos, Vector3.UP)
	
func self_drive():
	$Car.heading = $TrackPath.get_path_direction($Car.transform.origin)	
