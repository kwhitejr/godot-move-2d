class_name Utils

extends Resource


static func get_typed_children(node : Node, type : Variant) -> Array[Node]:
	return node.get_children().filter(func(child): return is_instance_of(child, type))
