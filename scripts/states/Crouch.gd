extends State

signal took_damage_in_crouch(damage)

func enter(_msg := {}) -> void:
	owner.velocity = Vector2.ZERO
	
	# Load the crouch animation
	state_machine.animated_sprite_2d.play("crouch")
	
func update(delta: float) -> void:
	
	owner.player_pos = state_machine.animated_sprite_2d.global_position
	owner.enemy_pos = owner.dummy_enemy_reference.global_position
	
	if not owner.is_on_floor():
		# replace with fall or hurt action
		#   in the future?
		state_machine.transition_to("Jump")
		return

	if InputBuffer.is_action_press_buffered("jump_neutral_%s" % [owner.player_id]):
		# We can use a msg dictionary to tell the
		#   next state that we want to do neutral
		#   jump
		state_machine.transition_to("Jump", {do_jump = true})
	elif (InputBuffer.is_action_press_buffered("move_left_%s" % [owner.player_id]) or InputBuffer.is_action_press_buffered("move_right_%s" % [owner.player_id])) and !InputBuffer.is_action_press_buffered("crouch"):
			state_machine.transition_to("Walk")

	
	# [ ---------------------------------------------
	# Directional Blocking code block for player
	# Implement something similar with the player,
	#   then make it standardized using state transitions
	if ((owner.player_pos - owner.enemy_pos) >= Vector2(0.0, 0.0) && InputBuffer.is_action_press_buffered("move_right_%s" % [owner.player_id])) || \
		((owner.player_pos - owner.enemy_pos) < Vector2(0.0, 0.0) && InputBuffer.is_action_press_buffered("move_left_%s" % [owner.player_id])) \
		&& not (InputBuffer.is_action_press_buffered("move_left_s" % [owner.player_id]) && InputBuffer.is_action_press_buffered("move_right_%s" % [owner.player_id])):
		#dummy_animated_sprite_2d.play("debug_block")
		owner.is_player_blocking = true
	else:
		#dummy_animated_sprite_2d.play(("debug_idle"))
		owner.is_player_blocking = false
		
	#print("crouch: is_player_blocking: " + str(owner.is_player_blocking))
	# --------------------------------------------- ]

	



func physics_update(delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("move_right_%s" % [owner.player_id])
		- Input.get_action_strength("move_left_%s" % [owner.player_id])
	)
	
	if is_equal_approx(input_direction_x, 0.0) and !InputBuffer.is_action_press_buffered("crouch"):
		
		print("crouch: lknsdckndkjsnckncskdncksncskcnknskcnkn")
		
		state_machine.transition_to("Idle")


func collision_check(attack_damage, attack_pushback, attack_hitstun, \
					attack_block_pushback, attack_blockstun) -> void:
	if state_machine.animated_sprite_2d.get_animation() == "crouch":
		print("crouch: player is blocking: " + str(owner.is_player_blocking))
	
		print("crouch: collision_check: attack_damage is " + str(attack_damage) \
			+ ", attack_pushback is " + str(attack_pushback) \
			+ ", attack_hitstun is " + str(attack_hitstun) \
			+ ", attack_block_pushback is " + str(attack_block_pushback) \
			+ ", attack_blockstun is " + str(attack_blockstun))
			
	
		if owner.is_player_blocking:
			# Transition to blocking state (which plays blocking) or play the blocking animation
			print("crouch: I blocked. I got pushed back " + str(attack_block_pushback) \
					+ " units")
			print("crouch: I'm in blockston for " + str(attack_blockstun) + " frames")
			state_machine.transition_to("Stun", {do_block_crouch = true, \
										pushback = attack_block_pushback, \
										stun = attack_blockstun})
		else:
			# Transition to getting hit state (which plays getting hit) or play the getting hit animation
			print("crouch: I got hit! I took " + str(attack_damage) + " damage")
			print("crouch: I got pushed back " + str(attack_pushback) + " units")
			print("crouch: I'm in hitstun for " + str(attack_hitstun) + " frames")
			
			took_damage_in_crouch.emit(attack_damage)
			state_machine.transition_to("Stun", {do_hit_crouch = true, \
										pushback = attack_pushback, \
										stun = attack_hitstun})
