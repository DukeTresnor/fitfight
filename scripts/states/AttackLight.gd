extends State


# Not sure if this is correct...
signal light_attack_hit(light_attack_damage, light_attack_pushback, \
	attack_light_hitstun, attack_light_block_pushback, attack_light_blockstun)
#signal light_attack_blocked(light_attack_pushback, light_attack_block_pushback)

signal took_damage_in_attack_light(damage)

# AttackLight constants. Change to load from some character holder script
const ATTACK_LIGHT_DAMAGE: int = 5
const ATTACK_LIGHT_PUSHBACK: int = 1
const ATTACK_LIGHT_HITSTUN: int = 1
# This will be some modifier to the base knockback above that is applied on block
const ATTACK_LIGHT_BLOCK_PUSHBACK: int = 1
const ATTACK_LIGHT_BLOCKSTUN: int = 1

const ATTACK_LIGHT_REPEAT_NUMBER: int = 0

# This should be linked / matched to the player's attack_light animation
const ATTACK_LIGHT_DURATION: int = 7

const ATTACK_LIGHT_CANCELABLE_FRAME: int = 3


# References to player_1's hitboxes for the AttackLightCollision Area2D node
@onready var attack_light_collision = $"../../AttackLightCollision"

# Get a reference to the player's state_machine in order to check its flip_h property
#   Already have this reference since we inherit from the state machine

var attack_light_repeat_count = 0

func enter(_msg := {}) -> void:
	
	# When you enter attack light, playe the attack_light animation using the state_machine's animated_sprite_2d
	state_machine.animated_sprite_2d.play("attack_light")
	
	
	# turn on hit and hurtboxes that need to be active
	#	ie the ones that are attatched to an associated area 2D node (not the AttackLight
	#   state machine node)
	# make sure that these hit and hurt boxes are only active for a specific number of
	#   frames
	# Not sure if I need to turn off the attacklighthitbox here
	attack_light_collision.get_node("AttackLightHitBox").disabled = true
	attack_light_collision.get_node("AttackLightHurtBox").disabled = false

func _process(delta):
	pass
	
func update(delta: float) -> void:
	#if state_machine.animated_sprite_2d.get_animation() == "attack_light":
	
	
	# turn the hitbox on at frame 3
	if state_machine.animated_sprite_2d.get_frame() == 3:
		attack_light_collision.get_node("AttackLightHitBox").disabled = false
	
	# turn the hitbox off at and after frame 5
	if state_machine.animated_sprite_2d.get_frame() >= 5:
		attack_light_collision.get_node("AttackLightHitBox").disabled = true
		
	# Attack Light is repeatable up to 3 times (might be up to 4 times...)
	# Change to 0 to prevent this ability for the moment
	if Input.is_action_just_pressed("attack_light") && attack_light_repeat_count < ATTACK_LIGHT_REPEAT_NUMBER \
			&& state_machine.animated_sprite_2d.get_frame() >= ATTACK_LIGHT_CANCELABLE_FRAME:
		# Reset the animation
		state_machine.animated_sprite_2d.set_frame(0)
		# Transition to AttackLight
		state_machine.transition_to("AttackLight")
		# Increase your attack_light_repeat_count to keep track of how many times
		#   you've repeated your light attack
		attack_light_repeat_count += 1
		# debug print
		print("attack_light: repeated attack")
		if attack_light_repeat_count == ATTACK_LIGHT_REPEAT_NUMBER:
			print("attack_light: reached maximum number of lights, wait till animation end")
			
	#attack_light_collision.get_node("AttackLightHitBox").disabled = false
	#print("attack_light: hitbox is disabled? " + str(attack_light_collision.get_node("AttackLightHitBox").disabled))
	#print("attack_light: frame number is " + str(state_machine.animated_sprite_2d.get_frame()))

	#print("attack_light: hitbox is disabled? " + str(attack_light_collision.get_node("AttackLightHitBox").disabled))


# Still need to implement stun transition logic for attacks
func collision_check(attack_damage, attack_pushback, attack_hitstun, \
					attack_block_pushback, attack_blockstun) -> void:
	if state_machine.animated_sprite_2d.get_animation() == "attack_light":
		print("attack_light: player_1 is blocking: " + str(owner.is_player_1_blocking))
	
		print("attack_light: collision_check: attack_damage is " + str(attack_damage) \
			+ ", attack_pushback is " + str(attack_pushback) \
			+ ", attack_hitstun is " + str(attack_hitstun) \
			+ ", attack_block_pushback is " + str(attack_block_pushback) \
			+ ", attack_blockstun is " + str(attack_blockstun))
			
	
		if owner.is_player_1_blocking:
			# Transition to blocking state (which plays blocking) or play the blocking animation
			print("attack_light: I blocked. I got pushed back " + str(attack_block_pushback) \
					+ " units")
			print("attack_light: I'm in blockston for " + str(attack_blockstun) + " frames")
			print("attack_light: I blocked, but I'm in attack_light, which means I can't block")
			print("attack_light: debugging, I should take damage")
		else:
			# Transition to getting hit state (which plays getting hit) or play the getting hit animation
			print("attack_light: I got hit! I took " + str(attack_damage) + " damage")
			print("attack_light: I got pushed back " + str(attack_pushback) + " units")
			print("attack_light: I'm in hitstun for " + str(attack_hitstun) + " frames")
			
			took_damage_in_attack_light.emit(attack_damage)


func exit() -> void:
	pass	
		



func _on_animated_sprite_2d_frame_changed():
	# I think I found a solution, keep this here for now but remove once you start
	#   refining
	
	# This body might need to go in the update function?
	# Whenever a frame is changed, check if you're in the attack_light animation,
	#   then check if you're in startup, active, or cooldown
	#   During startup frames
	#	During active frames
	#		turn on AttackLightHitBox
	#   During cooldown frames
	#		turn off AttackLightHitBox
	#if state_machine.animated_sprite_2d.get_animation() == "attack_light":
		
	#	print("attack_light: lsknsldmclkcmld")
		#print("attack light: getting frame count of attack: " + str(state_machine.animated_sprite_2d.get_frame()))	
	pass


func _on_animated_sprite_2d_animation_finished():
	# When the animated sprite 2d node's animation property finishes, check if we're 
	#   in the attack_light animation
	if state_machine.animated_sprite_2d.get_animation() == "attack_light":
		# Turn off the hitboxes associated with the attack_light animation,
		#   if there are any that are still active (extended hurtboxes, for example)
		attack_light_collision.get_node("AttackLightHitBox").disabled = true
		attack_light_collision.get_node("AttackLightHurtBox").disabled = true		
		attack_light_repeat_count = 0
		
		# Transition to the Idle animation
		state_machine.transition_to("Idle")
		
	

		

# Works so far, need to handle repeated attacks when the collision is already
#   inside the given body
func _on_attack_light_collision_body_entered(body):
	if state_machine.animated_sprite_2d.get_animation() == "attack_light":
		# Replace "debug_enemies" with enemy, player 2, etc?
		if body.is_in_group("debug_enemies"):
			#print("attack_light: dummy enemy is blocking " + str(body.is_dummy_blocking))
			#print("attack_light: The opponent is blocking: " + str(owner.dummy_enemy_reference.is_dummy_blocking))
			#if owner.dummy_enemy_reference.is_dummy_blocking:
			#	print("attack_light: light attack collided with debug_enemeies member, but they blocked")
			#	# send block signal
			#	light_attack_blocked.emit(ATTACK_LIGHT_PUSHBACK, ATTACK_LIGHT_BLOCK_PUSHBACK)
			#else:
			#	print("attack_light: light attack collided with debug_enemies member")
			#	# send attack signal
			#	light_attack_hit.emit(ATTACK_LIGHT_DAMAGE, ATTACK_LIGHT_PUSHBACK)
			light_attack_hit.emit(ATTACK_LIGHT_DAMAGE, ATTACK_LIGHT_PUSHBACK, ATTACK_LIGHT_HITSTUN, ATTACK_LIGHT_BLOCK_PUSHBACK, ATTACK_LIGHT_BLOCKSTUN)
				
			# This is good, still need to connect these signals to the dummy_enemy script
			#   so that it's properly referenced
			# how do I do this? Probably have to do it manually with the connect() function
			#   hopefully I can use the editor...
