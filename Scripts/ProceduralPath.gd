extends Path

var rand_gen = RandomNumberGenerator.new()
var amin = 50
var amax = 100
var bmin = 50
var bmax = 100
var h = 0 # height of track
var vertices = []
var start_pos = Vector3.ZERO
var next_pos = Vector3.ZERO
# radius of distortion of the mid-points is f(d/2) where d is distance between two points
# roughness [0, 1]
var f = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_gen.randomize()

func generate_path():
	sample_ellipse()
	distort()
	smoothen()
	curve.clear_points()
	for v in vertices:
		curve.add_point(v - vertices[0])
	print("Path with " + str(curve.get_point_count()) + " vertices created")
	var n = vertices.size()
	#start_pos = vertices[0]
	# go clockwise or counter clockwise at random
	var dir_idx = rand_gen.randi_range(0, 1)
	if dir_idx == 0:
		next_pos = vertices[1]
	else:
		next_pos = vertices[n - 1]
	

func sample_ellipse():
	# starting number of random points
	var num_points = rand_gen.randi_range(4, 12)
	vertices = []
	var a = rand_gen.randf_range(amin, amax)
	var b = rand_gen.randf_range(bmin, bmax)
	var angles = []
	for i in range(num_points):
		angles.append(2.0 * PI * (i + rand_gen.randf_range(-f/2, f/2)) / num_points)
	angles.sort()
	for theta in angles:
		vertices.append(Vector3(a * cos(theta) , h, b * sin(theta)))

# add midpoints and randomly move them to either side
func distort():
	var new_vertices = []
	var n = vertices.size()
	for i in range(n):
		var v1 = vertices[i]
		var v2 = vertices[(i + 1) % n]
		var mp = (v1 + v2) / 2
		var r = (v1 - v2).length() * f / 2
		var angle = rand_gen.randf_range(0, 2 * PI)
		var v = Vector3(mp.x + r * cos(angle), mp.y, mp.z + r * sin(angle))
		new_vertices.append(v1)
		new_vertices.append(v)
	vertices = new_vertices

# create a spline out of the points
func smoothen():
	var new_vertices = []
	var points_on_one_curve = 12 # including the first control point
	var n = vertices.size()
	for i in range(n):
		var v1 = vertices[i]
		var v2 = vertices[(i + 1) % n]
		var v3 = vertices[(i + 2) % n]
		var v4 = vertices[(i + 3) % n]
		for j in range(points_on_one_curve):
			var T = 1.0 * j / points_on_one_curve
			var v = cr_alpha(v1, v2, v3, v4, T)
			new_vertices.append(v)
	vertices = new_vertices

#uniform Catmull Rom
func cr_alpha(v1, v2, v3, v4, T):
	#var alpha = 0 # uniform
	#var alpha = 0.5 # centripetal
	var alpha = 1 # chordal 
	var t0 = 0
	var t1 = pow((v2 - v1).length(), alpha) + t0
	var t2 = pow((v3 - v2).length(), alpha) + t1
	var t3 = pow((v4 - v3).length(), alpha) + t2
	# t should be between t1 and t2
	var t = t1 + (t2 - t1) * T
	return catmull_rom_interp(v1, v2, v3, v4, t0, t1, t2, t3, t)
			
func catmull_rom_interp(v1, v2, v3, v4, t0, t1, t2, t3, t):
	var a1 = ((t1 - t) * v1 + (t - t0) * v2) / (t1 - t0)
	var a2 = ((t2 - t) * v2 + (t - t1) * v3) / (t2 - t1)
	var a3 = ((t3 - t) * v3 + (t - t2) * v4) / (t3 - t2)
	var b1 = ((t2 - t) * a1 + (t - t0) * a2) / (t2 - t0)
	var b2 = ((t3 - t) * a2 + (t - t1) * a3) / (t3 - t1)
	return ((t2 - t) * b1 + (t - t1) * b2) / (t2 - t1)
