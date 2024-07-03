extends Node2D

var SnakeBodyPart = preload("res://SnakeBodyPart.tscn")
var tail_segments = []
var viewport_rect = Vector2()

func is_position_inside_window(new_position: Vector2) -> bool:
	return new_position.x >= 0 and new_position.y >= 0 and \
		   new_position.x < viewport_rect.size.x and new_position.y < viewport_rect.size.y

func move_to_opposite_side_of_window(new_position: Vector2) -> Vector2:
	var window_width = viewport_rect.size.x
	var window_height = viewport_rect.size.y
	
	var dx = window_width - new_position.x
	var dy = window_height - new_position.y
	
	var new_x = 0 if dx <= 0 else window_width if dx >= window_width else new_position.x
	var new_y = 0 if dy <= 0 else window_height if dy >= window_height else new_position.y
	
	return Vector2(new_x, new_y)

func move_snake(move_direction: Vector2, move_speed: int):
	viewport_rect = get_viewport().get_visible_rect()
	var move_vec = move_direction * move_speed
	
	var arrayinv = tail_segments.duplicate()
	arrayinv.reverse()
	
	for segmentIdx in arrayinv.size():
		if segmentIdx == arrayinv.size() - 1:
			arrayinv[segmentIdx].position = position + move_vec
		else:
			arrayinv[segmentIdx].position = arrayinv[segmentIdx + 1].position
			
	var new_position = position + move_vec
	
	if !is_position_inside_window(new_position):
		position = move_to_opposite_side_of_window(new_position)
		print(position)
	else:
		position = new_position

func _ready():
	$Area2D.area_entered.connect(_on_area_entered)

func _on_area_entered(body):
	if body.name == "FoodArea":
		var newTailSegment = SnakeBodyPart.instantiate()
		
		var size = $Sprite2D.get_rect().size
		size = Vector2(500, 500)
		if !tail_segments.is_empty():
			var lastSegment = tail_segments.back()
			newTailSegment.position = lastSegment.position + size
		else:
			newTailSegment.position = position + size
			
		tail_segments.append(newTailSegment)
		call_deferred("add_sibling", newTailSegment)
		
