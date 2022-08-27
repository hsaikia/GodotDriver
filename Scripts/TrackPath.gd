extends Spatial

var start_pos = Vector3.ZERO
var next_pos = Vector3.ZERO

onready var path = $ProceduralPath
onready var path_follow = $ProceduralPath/PathFollow
onready var body = $ProceduralPath/PathFollow/KinematicBody

var speed = 20.0

func _ready():
	path.generate_path()
	body.transform.origin = path.start_pos

func _physics_process(delta):
	path_follow.offset += delta * speed

# Called when the node enters the scene tree for the first time.
func regenerate():
	path.generate_path()
	start_pos = path.start_pos
	next_pos = path.next_pos

func get_path_direction(pos):
	var offset = path.curve.get_closest_offset(pos)
	path_follow.offset = offset
	var new_pos = path_follow.transform.origin
	return new_pos.angle_to(pos)
	
