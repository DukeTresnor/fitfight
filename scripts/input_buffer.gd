extends Node
# Keeps track of recent inputs in order to make timing windows more flexible.
# Intended use: Add this file to your project as an Autoload script and have other objects call the class' methods.
# (more on AutoLoad: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

# How many milliseconds ahead of time the player can make an input and have it still be recognized.
# I chose the value 150 because it imitates the 9-frame buffer window in the Super Smash Bros. Ultimate game.
const BUFFER_WINDOW: int = 150
# The godot default deadzone is 0.2 so I chose to have it the same
const JOY_DEADZONE: float = 0.2

const MOVEMENT_ORDER_QUEUE_SIZE: int = 7

var keyboard_timestamps: Dictionary
var joypad_timestamps: Dictionary
var movement_order_queue
var input_quad = Vector2(0, 0)
var previous_quad_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE

	# Initialize all dictionary entris.
	keyboard_timestamps = {}
	joypad_timestamps = {}
	# order_queue can have Vector2 values for directions, or string values
	#   for button events?
	movement_order_queue = []
	
	movement_order_queue.resize(MOVEMENT_ORDER_QUEUE_SIZE)
	for element in MOVEMENT_ORDER_QUEUE_SIZE:
		#print(order_queue[element])
		movement_order_queue[element] = Vector2(2, 2)

# Called whenever the player makes an input.
func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		#print("input_buffer: ding; event is: " + str(event))
		if !event.pressed or event.is_echo():
			return

		var scancode: int = event.keycode
		#print("input_buffer: scancode: " + str(scancode))
		keyboard_timestamps[scancode] = Time.get_ticks_msec()
	
	elif event is InputEventJoypadButton:
		if !event.pressed or event.is_echo():
			return
			
		var button_index: int = event.button_index
		joypad_timestamps[button_index] = Time.get_ticks_msec()
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) < JOY_DEADZONE:
			return

		var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
		joypad_timestamps[axis_code] = Time.get_ticks_msec()




func _process(_delta):
	#print("input_buffer: testing values: keyboard_timestamps: " + \
	#	str(keyboard_timestamps))
	_get_movement_input()
	print("input_buffer: testing order_queue: " + str(movement_order_queue))
	#pass


func _get_movement_input() -> void:
	if InputBuffer.is_action_press_buffered("move_left") && !InputBuffer.is_action_press_buffered("move_right"):
		input_quad.x = -1
	elif InputBuffer.is_action_press_buffered("move_right") && !InputBuffer.is_action_press_buffered("move_left"):
		input_quad.x = 1
	else:
		input_quad.x = 0
	
	if InputBuffer.is_action_press_buffered("jump_neutral") && !InputBuffer.is_action_press_buffered("crouch"):
		input_quad.y = 1
	elif InputBuffer.is_action_press_buffered("crouch") && !InputBuffer.is_action_press_buffered("jump_neutral"):
		input_quad.y = -1
	else:
		input_quad.y = 0
		
	if input_quad == previous_quad_value:
		return
	else:
		# Populate order_queue with the input
		previous_quad_value = input_quad
		for order_index in MOVEMENT_ORDER_QUEUE_SIZE-1:
			movement_order_queue[order_index] = movement_order_queue[order_index+1]
		movement_order_queue[MOVEMENT_ORDER_QUEUE_SIZE-1] = input_quad
# Returns whether any of the keyboard keys or joypad buttons in the given action were pressed within the buffer window.
# This is currently not returning true
func is_action_press_buffered(action: String) -> bool:
	#print("input_buffer: dong; action is: " + str(action))
	
	#print("input_buffer: getting input map action? " + str(InputMap.action_get_events(action)))
	
	# Get the inputs associated with the action. If any one of them was pressed in the last BUFFER_WINDOW milliseconds,
	# the action is buffered.
	for event in InputMap.action_get_events(action):
		#print("input_buffer: the current event: " + str(event.keycode))
		#print("input_buffer: the current event: " + str(event))
		#print("input_buffer: type of the current event: " + type_string(typeof(event)))
		
		
		if event is InputEventKey:
			#print("input_buffer: keycode for event " + str(event.physical_keycode))
			var scancode: int = event.physical_keycode
			#print("input_buffer: scancode: " + str(scancode))
			#print("input_buffer: ___ keyboard_timestamps.has(scancode): " + str(keyboard_timestamps.has(scancode)))
			if keyboard_timestamps.has(scancode):
				var keyboard_delta = Time.get_ticks_msec() - keyboard_timestamps[scancode]
				#print("input_buffer: keyboard_delta: " + str(keyboard_delta))		

				#if action == "move_right" || action == "move_left":				
				#	print("input_buffer: for action " + str(action) + " --> Time.get_ticks_msec(), keyboard_timestamps[scancode] into difference: " + \
				#			str(Time.get_ticks_msec()) + ", " + str(keyboard_timestamps[scancode]) + \
				#			", " + str(keyboard_delta))
				
				if Time.get_ticks_msec() - keyboard_timestamps[scancode] <= BUFFER_WINDOW:
					# Prevent this method from returning true repeatedly and registering duplicate actions.					
					_invalidate_action(action)
		
					return true
					
		elif event is InputEventJoypadButton:
			var button_index: int = event.button_index
			if joypad_timestamps.has(button_index):
				var delta = Time.get_ticks_msec() - joypad_timestamps[button_index]
				if delta <= BUFFER_WINDOW:
					_invalidate_action(action)
					return true
		elif event is InputEventJoypadMotion:
			if abs(event.axis_value) < JOY_DEADZONE:
				return false
			var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
			if joypad_timestamps.has(axis_code):
				var delta = Time.get_ticks_msec() - joypad_timestamps[axis_code]
				if delta <= BUFFER_WINDOW:
					_invalidate_action(action)
					return true
	# If there's ever a third type of buffer-able action (mouse clicks maybe?), it'd probably be worth it to generalize
	# the repetitive keyboard/joypad code into something that works for any input method. Until then, by the YAGNI
	# principle, the repetitive stuff stays >:)
	
	return false


# Records unreasonable timestamps for all the inputs in an action. Called when IsActionPressBuffered returns true, as
# otherwise it would continue returning true every frame for the rest of the buffer window.
func _invalidate_action(action: String) -> void:
	
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var scancode: int = event.keycode
			if keyboard_timestamps.has(scancode):
				keyboard_timestamps[scancode] = 0
		elif event is InputEventJoypadButton:
			var button_index: int = event.button_index
			if joypad_timestamps.has(button_index):
				joypad_timestamps[button_index] = 0
		elif event is InputEventJoypadMotion:
			var axis_code: String = str(event.axis) + "_" + str(sign(event.axis_value))
			if joypad_timestamps.has(axis_code):
				joypad_timestamps[axis_code] = 0
