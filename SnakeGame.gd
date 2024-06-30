extends Node2D

var Food = preload("res://Food.tscn")
var SnakeBody = preload("res://SnakeBody.tscn")

var movement_direction = Vector2.UP
var snakeBodyInstance = SnakeBody.instantiate()
var foodInstance = Food.instantiate()

var snake_speed = 2

func spawn_food():
	var food_x = randi_range(100, 500)
	var food_y = randi_range(100, 500)
	foodInstance.position = Vector2(food_x, food_y)
	#add_child(foodInstance)

# Called when the node enters the scene tree for the first time.
func _ready():
	#foodInstance.food_eaten.connect(consume_food)
	
	spawn_food()
	add_child(foodInstance)
	
	snakeBodyInstance.position = Vector2(150, 222)
	add_child(snakeBodyInstance)

func consume_food():
	print("test slot")
	#remove_child(foodInstance)
	spawn_food()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input()
	update_position(delta)

func handle_input():
	if Input.is_action_pressed("ui_up"):
		movement_direction = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		movement_direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_left"):
		movement_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		movement_direction = Vector2.RIGHT
	
	if Input.is_action_pressed("ui_custom_run"):
		snake_speed = 10
	elif Input.is_action_just_released("ui_custom_run"):
		snake_speed = 2

func update_position(delta):
	#snakeBodyInstance.position += movement_direction * snake_speed
	snakeBodyInstance.move_snake(movement_direction, snake_speed)
