extends State

signal took_damage_in_stun(damage)

var pushback: int = 0
var stun_counter: int = 0
var stun_duration: int
var push_direction_x: int = -1 # Figure out logic for this
# Either get position information, flip status of a player, or collision information
var state_to_return_to: String


# Getting weird visual error with when doing crouch + block
#   Investigate
func enter(msg := {}) -> void:
	# Logic to determine which blocking or hit animation to play
	# To Do: Make into switch case?
	if msg.has("do_block_stand"):	
		state_machine.animated_sprite_2d.play("block_stand")
		state_to_return_to = "Idle"
		
	if msg.has("do_block_crouch"):
		state_machine.animated_sprite_2d.play("block_crouch")
		state_to_return_to = "Crouch"

	if msg.has("do_block_air"):
		state_machine.animated_sprite_2d.play("block_air")
		state_to_return_to = "Jump"

	if msg.has("do_hit_stand"):	
		state_machine.animated_sprite_2d.play("hit_stand")
		state_to_return_to = "Idle"
		
	if msg.has("do_hit_crouch"):
		state_machine.animated_sprite_2d.play("hit_crouch")
		state_to_return_to = "Crouch"

	if msg.has("do_hit_air"):
		state_machine.animated_sprite_2d.play("hit_air")
		state_to_return_to = "Jump"
		
	
	if msg.has("pushback"):
		pushback = msg.get("pushback")

	if msg.has("stun"):
		stun_duration = msg.get("stun")


	# Debug printing
	print("stun: pushback: " + str(pushback))
	print("stun: stun_duration: " + str(stun_duration))
	print("stun: key list in dictionary: " + str(msg.keys()))

'''
		state_machine.transition_to("Stun", {do_block_stand = true, \
										pushback = attack_block_pushback, \
										stun = attack_blockstun})
'''


func update(delta: float) -> void:
	# this logic needs to be focused around delta to keep it consistent with the
	# game's framerate
	#   ie I probably should not be transitioning based on an integer counter
	
	# Increment stun_counter until we reach the end of the amount of the attack's stun
	stun_counter += 60.0 * delta
	# Debug
	#print("stun: stun_counter: " + str(stun_counter))

	#print("stun: 1/delta: " + str(1.0 / delta))


	if stun_counter >= stun_duration:
		#stun_counter = 0
		state_machine.transition_to(state_to_return_to)

func physics_update(delta: float) -> void:
#func _physics_process(delta: float):
	# Needs to be different than this
	var propotional_debug = delta * pushback / stun_duration
	
	# Use delta in calculations determining how the player's should move 
	# Needs logic or push_diretion_x -- should be based on direction the
	#   attack came from or from the flipped state of the players
	# Not sure if this is what I want at the moment or over time	
	#owner.velocity.x = owner.SPEED * push_direction_x
	owner.velocity.x += propotional_debug * push_direction_x
	#owner.velocity.y += owner.gravity * delta
	
	owner.move_and_slide()

	# Debug
	#print("stun: player velocity.x: " + str(owner.velocity.x))
	
	'''
	owner.velocity.x = owner.SPEED * input_direction_x
	owner.velocity.y += owner.gravity * delta
	#owner.velocity = owner.move_and_slide()
	owner.move_and_slide()
	'''
	# Code from walk state to move the player, apply here appropriately
	# I need to replace input_direction_x with the direction coming from 
	#   the opposing player / dummy enemy

	

func collision_check(attack_damage, attack_pushback, attack_hitstun, \
					attack_block_pushback, attack_blockstun) -> void:
	if state_machine.animated_sprite_2d.get_animation() == "hit_stand" \
		|| state_machine.animated_sprite_2d.get_animation() == "block_stand" \
		|| state_machine.animated_sprite_2d.get_animation() == "hit_crouch" \
		|| state_machine.animated_sprite_2d.get_animation() == "block_crouch" \
		|| state_machine.animated_sprite_2d.get_animation() == "hit_air" \
		|| state_machine.animated_sprite_2d.get_animation() == "block_air":
		
		print("stun: player is blocking: " + str(owner.is_player_blocking))
	
		print("stun: collision_check: attack_damage is " + str(attack_damage) \
			+ ", attack_pushback is " + str(attack_pushback) \
			+ ", attack_hitstun is " + str(attack_hitstun) \
			+ ", attack_block_pushback is " + str(attack_block_pushback) \
			+ ", attack_blockstun is " + str(attack_blockstun))

	
		if owner.is_player_blocking:
			# Transition to blocking state (which plays blocking) or play the blocking animation
			print("stun: I blocked. I got pushed back " + str(attack_block_pushback) \
					+ " units")
			print("stun: I'm in blockston for " + str(attack_blockstun) + " frames")
			state_machine.transition_to("Stun", {do_block_stand = true, \
										pushback = attack_block_pushback, \
										stun = attack_blockstun})
		else:
			# Transition to getting hit state (which plays getting hit) or play the getting hit animation
			print("stun: I got hit! I took " + str(attack_damage) + " damage")
			print("stun: I got pushed back " + str(attack_pushback) + " units")
			print("stun: I'm in hitstun for " + str(attack_hitstun) + " frames")
			
			took_damage_in_stun.emit(attack_damage)
			
			state_machine.transition_to("Stun", {do_hit_stand = true, \
										pushback = attack_pushback, \
										stun = attack_hitstun})




func exit() -> void:
	stun_counter = 0
	#pass
