extends State

signal took_damage_in_idle(damage)

#var player_pos
#var dummy_pos

func enter(_msg := {}) -> void:
	owner.velocity = Vector2.ZERO
	
	# When you enter idle, playe the idle animation using the state_machine's animated_sprite_2d
	state_machine.animated_sprite_2d.play("idle")
	
func update(delta: float) -> void:
	# Assigning for easy reference
	owner.player_pos = state_machine.animated_sprite_2d.global_position
	#dummy_pos = owner.dummy_enemy_reference.global_position
	owner.enemy_pos = owner.dummy_enemy_reference.global_position
	
	
	if not owner.is_on_floor():
		# replace with fall or hurt action
		#   in the future?
		state_machine.transition_to("Jump")
		return

	if owner.is_on_floor():
		
		# [ ---------------------------------------------
		# Code logic to switch the player based on location relative to the enemy
		# Has a lot of bugs -- works! Keep an eye on it
		# This might need to be placed inside the general player script for all
		#   of the different player states to reference to and look at
		#   Doing it that way would mean that the player always changes direction,
		#     instead of only switching in the idle state
		#   Right now, the player would not switch directions even after a double jump,
		#     for example
		# Implementing inside of player script doesn't work b/c of my state implementation,
		#   I need to implement this in any particular state that wants this behavior...
		if owner.player_pos - owner.enemy_pos >= Vector2(0.0, 0.0):
			#state_machine.animated_sprite_2d.set_flip_h(true)
			#state_machine.animated_sprite_2d.set_flip_v(true)
			owner.rotation = -PI
			#owner.scale.x = -1
			owner.scale.y = -1
			
		else:
			#state_machine.animated_sprite_2d.set_flip_h(false)
			owner.rotation = 0.0
			#owner.scale.x = 1
			owner.scale.y = 1
		# --------------------------------------------- ]

		# Some debug print statements
		# These print statements are to see what the global position of each other player
		#   I'm not sure how to reference the enemey's location atm
		#   I think something has to do with me not getting the reference to DummyEnemy properly
		#		look into?
		# Look into the look_at() function as well
		#print("idle: dummy_enemy location: " + str(dummy_pos))
		#print("idle: player location: " + str(player_pos))	
		#print("idle: player location - dummy_enemy location: " + str(player_pos - dummy_pos))
		#print("idle: player horizontal scale: " + str(owner.scale.x))
	
		

		# [ ---------------------------------------------
		# Directional Blocking code block for player
		# Implement something similar with the player,
		#   then make it standardized using state transitions
		if ((owner.player_pos - owner.enemy_pos) >= Vector2(0.0, 0.0) && InputBuffer.is_action_press_buffered("move_right_%s" % [owner.player_id])) || \
			((owner.player_pos - owner.enemy_pos) < Vector2(0.0, 0.0) && InputBuffer.is_action_press_buffered("move_left_%s" % [owner.player_id])) \
			&& not (InputBuffer.is_action_press_buffered("move_left_%s" % [owner.player_id]) && InputBuffer.is_action_press_buffered("move_right_%s" % [owner.player_id])):
			#dummy_animated_sprite_2d.play("debug_block")
			owner.is_player_blocking = true
		else:
			#dummy_animated_sprite_2d.play(("debug_idle"))
			owner.is_player_blocking = false
			
		#print("idle: is_player_blocking_in_idle: " + str(owner.is_player_blocking))
		# --------------------------------------------- ]

	if InputBuffer.is_action_press_buffered("jump_neutral_%s" % [owner.player_id]):
	#	print("Idle: testing jump_neutral")
	#if Input.is_action_just_pressed("jump_neutral"):
		# We can use a msg dictionary to tell the
		#   next state that we want to do neutral
		#   jump
		state_machine.transition_to("Jump", {do_jump = true})
		
	if InputBuffer.is_action_press_buffered("move_left_%s" % [owner.player_id]) or InputBuffer.is_action_press_buffered("move_right_%s" % [owner.player_id]):
	#elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			
			
			
			state_machine.transition_to("Walk")
			
	# Excess logic checking here -- don't need the move left or right check?
	if InputBuffer.is_action_press_buffered("crouch") or \
		(InputBuffer.is_action_press_buffered("crouch") and \
			(InputBuffer.is_action_press_buffered("move_left_s" % [owner.player_id]) || InputBuffer.is_action_press_buffered("move_right_%s" % [owner.player_id]))):
			state_machine.transition_to("Crouch")


	if InputBuffer.is_action_press_buffered("attack_light"):
		state_machine.transition_to("AttackLight")
	





func collision_check(attack_damage, attack_pushback, attack_hitstun, \
					attack_block_pushback, attack_blockstun) -> void:
	if state_machine.animated_sprite_2d.get_animation() == "idle":
		print("idle: player is blocking: " + str(owner.is_player_blocking))
	
		print("idle: collision_check: attack_damage is " + str(attack_damage) \
			+ ", attack_pushback is " + str(attack_pushback) \
			+ ", attack_hitstun is " + str(attack_hitstun) \
			+ ", attack_block_pushback is " + str(attack_block_pushback) \
			+ ", attack_blockstun is " + str(attack_blockstun))
			
	
		if owner.is_player_blocking:
			# Transition to blocking state (which plays blocking) or play the blocking animation
			#   Edit -- this is now enting the Stun state with a "block" message
			print("idle: I blocked. I got pushed back " + str(attack_block_pushback) \
					+ " units")
			print("idle: I'm in blockstun for " + str(attack_blockstun) + " frames")
			# Enter the stun state
			state_machine.transition_to("Stun", {do_block_stand = true, \
										pushback = attack_block_pushback, \
										stun = attack_blockstun})
			
		else:
			# Transition to getting hit state (which plays getting hit) or play the getting hit animation
			#   Edit -- this is now enting the Stun state with a "hit" message
			print("idle: I got hit! I took " + str(attack_damage) + " damage")
			print("idle: I got pushed back " + str(attack_pushback) + " units")
			print("idle: I'm in hitstun for " + str(attack_hitstun) + " frames")
			
			# Change the player's health since they took damage
			#owner.player_health_bar._set_health(owner.player_health_bar.health - attack_damage)
			took_damage_in_idle.emit(attack_damage)
			
			# Enter the Stun state
			state_machine.transition_to("Stun", {do_hit_stand = true, \
										pushback = attack_pushback, \
										stun = attack_hitstun})
	
	
	
# Is this needed anymore?
func _on_player_enemy_attack_collision(attack_damage, attack_pushback, attack_hitstun, attack_block_pushback, attack_blockstun):
	# check for blocking here, if not blocking, player takes damage, transition states
	'''
	print("idle: the opponent is attacking me")
	print("idle: player is blocking: " + str(owner.is_player_blocking))

	if owner.is_player_blocking:
		# Transition to blocking state (which plays blocking) or play the blocking animation
		print("idle: I blocked. I got pushed back " + str(attack_block_pushback) \
				+ " units")
		print("idle: I'm in blockston for " + str(attack_blockstun) + " frames")
	else:
		if state_machine.animated_sprite_2d.get_animation() == "idle":
			# Transition to getting hit state (which plays getting hit) or play the getting hit animation
			print("idle: I got hit! I took " + str(attack_damage) + " damage")
			print("idle: I got pushed back " + str(attack_pushback) + " units")
			print("idle: I'm in hitstun for " + str(attack_hitstun) + " frames")
			
			# Change the player's health since they took damage
			#owner.player_health_bar._set_health(owner.player_health_bar.health - attack_damage)
			took_damage_in_idle.emit(attack_damage)	
	'''
	pass
