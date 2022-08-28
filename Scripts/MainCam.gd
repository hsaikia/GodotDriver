extends InterpolatedCamera

var index = 0

func _process(_delta):
	if Input.is_action_just_released("toggle_cam"):
		print("Toggled")
		index = (index + 1) % 3
		if index == 0:
			self.set_target(get_node("../Car/Camera_Target_TopDown"))
		elif index == 1:
			self.set_target(get_node("../Car/Camera_Target_Ego"))
		else:
			self.set_target(get_node("../Camera_TopDown_Static"))
