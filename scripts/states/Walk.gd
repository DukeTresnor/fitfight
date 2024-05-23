extends State

func enter(_msg := {}) -> void:
	state_machine.animated_sprite_2d.play("walk")

func physics_update(delta: float) -> void:
	if not owner.is_on_floor():
		state_machine.transition_to("Jump")
		return
		
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)

	owner.velocity.x = owner.SPEED * input_direction_x
	owner.velocity.y += owner.gravity * delta
	#owner.velocity = owner.move_and_slide()
	owner.move_and_slide()
	
	if Input.is_action_just_pressed("jump_neutral"):
		state_machine.transition_to("Jump", {do_jump = true})
	elif Input.is_action_just_pressed("crouch"):
		state_machine.transition_to("Crouch")
	elif is_equal_approx(input_direction_x, 0.0):	
		state_machine.transition_to("Idle")

	if Input.is_action_just_pressed("attack_light"):
		state_machine.transition_to("AttackLight")
