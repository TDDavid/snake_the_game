extends Node2D

var SnakeBodyPart = preload("res://SnakeBodyPart.tscn")
var tail_segments = []

func move_snake(move_direction: Vector2, move_speed: int):
	var move_vec = move_direction * move_speed
	
	var arrayinv = tail_segments.duplicate()
	arrayinv.reverse()
	
	for segmentIdx in arrayinv.size():
		if segmentIdx == arrayinv.size() - 1:
			arrayinv[segmentIdx].position = position + move_vec
		else:
			arrayinv[segmentIdx].position = arrayinv[segmentIdx + 1].position
			
	position += move_vec

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
		
