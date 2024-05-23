# Air.gd
extends State



# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		owner.velocity.y = -owner.JUMP_IMPULSE
		
		# change the animation to the jump animation
		#animated_sprite_2d.animation = "jump_neutral"
		#print("jump: animates_sprite_2d" + animated_sprite_2d.sprite_frames)
		state_machine.animated_sprite_2d.play("jump_neutral")
		
		#state_machine.animation_player.play("jump_neutral")


func physics_update(delta: float) -> void:
	# Horizontal movement.
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	# --- Have this enabled to allow movement through air ---
	owner.velocity.x = owner.SPEED * input_direction_x
	# Vertical movement.
	owner.velocity.y += owner.gravity * delta
	#owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
	owner.move_and_slide()

	# Landing.
	if owner.is_on_floor():
		if is_equal_approx(owner.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
