extends State

var player_pos
var dummy_pos

func enter(_msg := {}) -> void:
	owner.velocity = Vector2.ZERO
	
	# When you enter idle, playe the idle animation using the state_machine's animated_sprite_2d
	state_machine.animated_sprite_2d.play("idle")
	
func update(delta: float) -> void:
	
	if not owner.is_on_floor():
		# replace with fall or hurt action
		#   in the future?
		state_machine.transition_to("Jump")
		return

	if owner.is_on_floor():
		# Assigning for easy reference
		player_pos = state_machine.animated_sprite_2d.global_position
		dummy_pos = owner.dummy_enemy_reference.global_position
		
		# Code logic to switch the player based on location relative to the enemy
		# Has a lot of bugs -- works! Keep an eye on it
		if player_pos - dummy_pos >= Vector2(0.0, 0.0):
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

		# Some debug print statements
		# These print statements are to see what the global position of each other player
		#   I'm not sure how to reference the enemey's location atm
		#   I think something has to do with me not getting the reference to DummyEnemy properly
		#		look into?
		# Look into the look_at() function as well
		#print("idle: dummy_enemy location: " + str(dummy_pos))
		#print("idle: player_1 location: " + str(player_pos))	
		#print("idle: player_1 location - dummy_enemy location: " + str(player_pos - dummy_pos))
		#print("idle: player_1 horizontal scale: " + str(owner.scale.x))
	
	
	
	
	if Input.is_action_just_pressed("jump_neutral"):
		# We can use a msg dictionary to tell the
		#   next state that we want to do neutral
		#   jump
		
		state_machine.transition_to("Jump", {do_jump = true})
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			state_machine.transition_to("Walk")
	elif Input.is_action_pressed("crouch"):
			state_machine.transition_to("Crouch")
			
	if Input.is_action_just_pressed("attack_light"):
		state_machine.transition_to("AttackLight")
	
