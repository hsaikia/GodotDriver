extends Node2D

var sensor_readings = []
var center = Vector2(100, 200)
var color = Color(1.0, 0.0, 0.0)
var width = 2.0
var scaling = 3.0

func _draw():
	var n = sensor_readings.size()
	for i in range(n):
		var dist = sensor_readings[i][0]
		var ang = sensor_readings[i][1]
		var pt = center + scaling * dist * Vector2(0, -1).rotated(-ang)
		draw_line(center, pt, color, width, true)
#	var radius = 80
#	var angle_from = 75
#	var angle_to = 195
#	var color = Color(1.0, 0.0, 0.0)
#	draw_line(points_arc[index_point], points_arc[index_point + 1], color)
