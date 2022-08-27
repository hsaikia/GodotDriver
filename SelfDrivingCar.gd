extends KinematicBody

var heading = 0
var speed = 10

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var velocity = speed * Vector3(cos(heading), 0, sin(heading))
	velocity = move_and_slide(velocity, Vector3.UP)
