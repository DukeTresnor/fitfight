extends State

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
	# Needs to be different than this
	var propotional_debug = delta * pushback / stun_duration
	
	# Use delta in calculations determining how the player's should move 
	# Needs logic or push_diretion_x -- should be based on direction the
	#   attack came from or from the flipped state of the players
	# Not sure if this is what I want at the moment or over time	
	#owner.velocity.x = owner.SPEED * push_direction_x
	owner.velocity.x = propotional_debug * push_direction_x
	#owner.velocity.y += owner.gravity * delta
	
	owner.move_and_slide()

	# Debug
	print("stun: player velocity.x: " + str(owner.velocity.x))
	
	'''
	owner.velocity.x = owner.SPEED * input_direction_x
	owner.velocity.y += owner.gravity * delta
	#owner.velocity = owner.move_and_slide()
	owner.move_and_slide()
	'''
	# Code from walk state to move the player, apply here appropriately
	# I need to replace input_direction_x with the direction coming from 
	#   the opposing player / dummy enemy

	




func exit() -> void:
	stun_counter = 0
	#pass
