# Air.gd
extends State

signal took_damage_in_jump(damage)

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		owner.velocity.y = -owner.JUMP_IMPULSE
		
		# change the animation to the jump animation
		#animated_sprite_2d.animation = "jump_neutral"
		#print("jump: animates_sprite_2d" + animated_sprite_2d.sprite_frames)
		state_machine.animated_sprite_2d.play("jump_neutral")
		
		#state_machine.animation_player.play("jump_neutral")


func update(delta: float) -> void:
	#print("jump:  player is blocking in the air " + str(owner.is_player_1_blocking))
	pass

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


# Issue here was that the state is called "jump_neutral"
# I should change the state name to be jump -- need to check other things regarding
#   that
func collision_check(attack_damage, attack_pushback, attack_hitstun, \
					attack_block_pushback, attack_blockstun) -> void:
		
	if state_machine.animated_sprite_2d.get_animation() == "jump_neutral":
		print("jump: player_1 is blocking: " + str(owner.is_player_1_blocking))
	
		print("jump: collision_check: attack_damage is " + str(attack_damage) \
			+ ", attack_pushback is " + str(attack_pushback) \
			+ ", attack_hitstun is " + str(attack_hitstun) \
			+ ", attack_block_pushback is " + str(attack_block_pushback) \
			+ ", attack_blockstun is " + str(attack_blockstun))
			
	
		if owner.is_player_1_blocking:
			# Transition to blocking state (which plays blocking) or play the blocking animation
			print("jump: I blocked. I got pushed back " + str(attack_block_pushback) \
					+ " units")
			print("jump: I'm in blockston for " + str(attack_blockstun) + " frames")
			state_machine.transition_to("Stun", {do_block_air = true, \
										pushback = attack_block_pushback, \
										stun = attack_blockstun})
		else:
			# Transition to getting hit state (which plays getting hit) or play the getting hit animation
			print("jump: I got hit! I took " + str(attack_damage) + " damage")
			print("jump: I got pushed back " + str(attack_pushback) + " units")
			print("jump: I'm in hitstun for " + str(attack_hitstun) + " frames")
			
			took_damage_in_jump.emit(attack_damage)
			state_machine.transition_to("Stun", {do_hit_air = true, \
										pushback = attack_pushback, \
										stun = attack_hitstun})

