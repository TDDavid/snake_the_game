extends Node2D

var Food = preload("res://Food.tscn")
var SnakeBody = preload("res://SnakeBody.tscn")

var movement_direction = Vector2.UP
var snakeBodyInstance = SnakeBody.instantiate()
var foodInstance = Food.instantiate()
var useMouseInput = false
var useUiActionInput = false
var snake_speed = 200

func move_food():
	var food_x = randi_range(100, 500)
	var food_y = randi_range(100, 500)
	foodInstance.position = Vector2(food_x, food_y)

# Called when the node enters the scene tree for the first time.
func _ready():
	snakeBodyInstance.food_eaten.connect(consume_food)
	
	move_food()
	add_child(foodInstance)
	
	snakeBodyInstance.position = Vector2(150, 222)
	add_child(snakeBodyInstance)

func consume_food():
	move_food()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input()
	update_position(delta)
	$VBoxContainer/Label.set_text("Score: %s" % snakeBodyInstance.tail_segments.size())
	$VBoxContainer/Label2.set_text("Input type: %s" % ("mouse" if useMouseInput else "key"))
	$VBoxContainer/Label3.set_text("FPS %d" % Engine.get_frames_per_second())

func handle_input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		useUiActionInput = false
		useMouseInput = true
	elif Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		useUiActionInput = true
		useMouseInput = false
		
	if useMouseInput:
		var mousePos = get_global_mouse_position()
		var distance = snakeBodyInstance.position.distance_to(mousePos)
		if distance > 40:
			movement_direction = snakeBodyInstance.position.direction_to(mousePos)
		else:
			var alfa = 10
			var beta = deg_to_rad(alfa)
			
			#var a = distance * cos(beta)
			#var b = sqrt(distance * distance - a * a)
			#var newPos = mousePos + Vector2(b, a)
			#movement_direction = snakeBodyInstance.position.direction_to(newPos)

			var a_translated = snakeBodyInstance.position - mousePos
			var c1 = a_translated[0] * cos(beta) - a_translated[1] * sin(beta)
			var c2 =  a_translated[1] * cos(beta) + a_translated[0] * sin(beta)
			var c_rotated = Vector2(c1, c2) + mousePos
			
			snakeBodyInstance.position = c_rotated
			#movement_direction = snakeBodyInstance.position.direction_to(c_rotated)
			movement_direction = Vector2(0, 0)
			
	elif useUiActionInput:
		movement_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		movement_direction = movement_direction.normalized()
		
	if Input.is_action_just_pressed("ui_accept"):
		foodInstance.print_tree_pretty()
		snakeBodyInstance._on_area_entered(foodInstance.get_child(1))
	
	if Input.is_action_pressed("ui_custom_run"):
		snake_speed = 500
	elif Input.is_action_just_released("ui_custom_run"):
		snake_speed = 200

func update_position(delta):
	snakeBodyInstance.move_snake(movement_direction, snake_speed * delta)
