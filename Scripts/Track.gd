extends Spatial

var start_pos = Vector3.ZERO
var next_pos = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func regenerate():
	get_node("TrackMesh").generate_points()
	start_pos = get_node("TrackMesh").start_pos
	next_pos = get_node("TrackMesh").next_pos
