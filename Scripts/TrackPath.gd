extends Spatial

var start_pos = Vector3.ZERO
var next_pos = Vector3.ZERO

onready var path = $ProceduralPath

var speed = 20.0

func _ready():
	path.generate_path()

# Called when the node enters the scene tree for the first time.
func regenerate():
	path.generate_path()
	start_pos = path.start_pos
	next_pos = path.next_pos
	
