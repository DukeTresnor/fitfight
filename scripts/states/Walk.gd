extends State

signal took_damage_in_walk(damage)

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


func collision_check(attack_damage, attack_pushback, attack_hitstun, \
					attack_block_pushback, attack_blockstun) -> void:
	if state_machine.animated_sprite_2d.get_animation() == "walk" \
		|| state_machine.animated_sprite_2d.get_animation() == "hit_stand" \
		|| state_machine.animated_sprite_2d.get_animation() == "block_stand":
		print("walk: player_1 is blocking: " + str(owner.is_player_1_blocking))
	
		print("walk: collision_check: attack_damage is " + str(attack_damage) \
			+ ", attack_pushback is " + str(attack_pushback) \
			+ ", attack_hitstun is " + str(attack_hitstun) \
			+ ", attack_block_pushback is " + str(attack_block_pushback) \
			+ ", attack_blockstun is " + str(attack_blockstun))
			
	
		if owner.is_player_1_blocking:
			# Transition to blocking state (which plays blocking) or play the blocking animation
			print("walk: I blocked. I got pushed back " + str(attack_block_pushback) \
					+ " units")
			print("walk: I'm in blockston for " + str(attack_blockstun) + " frames")
			state_machine.transition_to("Stun", {do_block_stand = true, \
										pushback = attack_block_pushback, \
										stun = attack_blockstun})
		else:
			# Transition to getting hit state (which plays getting hit) or play the getting hit animation
			print("walk: I got hit! I took " + str(attack_damage) + " damage")
			print("walk: I got pushed back " + str(attack_pushback) + " units")
			print("walk: I'm in hitstun for " + str(attack_hitstun) + " frames")
			
			took_damage_in_walk.emit(attack_damage)
			
			state_machine.transition_to("Stun", {do_hit_stand = true, \
										pushback = attack_pushback, \
										stun = attack_hitstun})
