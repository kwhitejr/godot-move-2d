class_name Constants


const FeatureVisualizationColors : Dictionary = {
	PINK = Color("#e61baab5"),
	BLUE = Color("#68e8ff"),
	GREEN = Color("#a9ff99"),
	YELLOW = Color("#ebff99"),
	ORANGE = Color("#ffb999"),
	PURPLE = Color("#e299fe"),
	WHITE = Color("#ffffff"),
	TRANSPARENT = Color(0, 0, 0, 0)
}

const DirectionsCardinal : Array[Vector2] = [
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.UP
]

const DirectionsOctogonal : Array[Vector2] = [
	Vector2.RIGHT,
	Vector2.RIGHT + Vector2.DOWN,
	Vector2.DOWN,
	Vector2.LEFT + Vector2.DOWN,
	Vector2.LEFT,
	Vector2.LEFT + Vector2.UP,
	Vector2.UP,
	Vector2.RIGHT + Vector2.UP,
]
