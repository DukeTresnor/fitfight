extends State

func enter(_msg := {}) -> void:
	owner.velocity = Vector2.ZERO
	
	# Load the crouch animation
	state_machine.animated_sprite_2d.play("crouch")
	
func update(delta: float) -> void:
	
	if not owner.is_on_floor():
		# replace with fall or hurt action
		#   in the future?
		state_machine.transition_to("Jump")
		return

	if Input.is_action_just_pressed("jump_neutral"):
		# We can use a msg dictionary to tell the
		#   next state that we want to do neutral
		#   jump
		state_machine.transition_to("Jump", {do_jump = true})
	elif (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and !Input.is_action_pressed("crouch"):
			state_machine.transition_to("Walk")


func physics_update(delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	if is_equal_approx(input_direction_x, 0.0) and !Input.is_action_pressed("crouch"):
		
		print("crouch: lknsdckndkjsnckncskdncksncskcnknskcnkn")
		
		state_machine.transition_to("Idle")
