extends Node2D

var buffer = []
var BUFFER_SIZE = 5
var TIMER_CONSTANT = 0.2
var input_direction_matrix = Vector2(0, 0)
var previous_value

@onready var buffer_timer = $BufferTimer


func _init() -> void:
	buffer.resize(BUFFER_SIZE)
	for val in BUFFER_SIZE:
		buffer[val] = Vector2(2, 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	buffer_timer.wait_time = TIMER_CONSTANT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_get_controller_input()
	# if Input.is_action_just_pressed("jump_neutral"):
	# etc.


func _get_controller_input() -> void:
	if Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		input_direction_matrix.x = -1
	elif Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left"):
		input_direction_matrix.x = 1
	else:
		input_direction_matrix.x = 0

func _on_buffer_timer_timeout():
	pass # Replace with function body.
