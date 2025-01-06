class_name Utils

extends Resource


static func get_typed_children(node : Node, type : Variant) -> Array[Node]:
	return node.get_children().filter(func(child): return is_instance_of(child, type))

static func get_rounded_vector(input_vector: Vector2, segments: float) -> Vector2:
	# Minimally return RIGHT or LEFT
	var min_segments = 2 
	segments = max(min_segments, segments)

	# Calculate the angle of the input_vector
	var input_angle := rad_to_deg(atan2(input_vector.y, input_vector.x))
	
	# Calculate the angle between each segment
	var angle_step := 360.0 / segments

	# Calculate the nearest snap angle
	var nearest_snap_angle : float = (round(input_angle / angle_step)) * angle_step

	# Convert the snap angle back to a Vector2 direction
	var snap_direction := Vector2.RIGHT.rotated(deg_to_rad(nearest_snap_angle))

	return snap_direction
