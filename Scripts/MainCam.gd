extends InterpolatedCamera

func _process(_delta):
	if Input.is_action_just_released("toggle_cam"):
		if self.get_target_path() == "../Car/Camera_Target_Ego": 
			self.set_target_path("../Car/Camera_Target_TopDown")
		else:
			self.set_target_path("../Car/Camera_Target_Ego")
