extends State


# Not sure if this is correct...
signal light_attack_hit(light_attack_damage, light_attack_pushback)
signal light_attack_blocked(light_attack_pushback, light_attack_block_pushback)

# AttackLight constants. Change to load from some character holder script
const ATTACK_LIGHT_DAMAGE: int = 5
const ATTACK_LIGHT_PUSHBACK: int = 1
# This will be some modifier to the base knockback above that is applied on block
const ATTACK_LIGHT_BLOCK_PUSHBACK: int = 1

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
	
func update(delta: float) -> void:
	#if state_machine.animated_sprite_2d.get_animation() == "attack_light":
		
	
	# turn the hitbox on at frame 1
	if state_machine.animated_sprite_2d.get_frame() == 1:
		attack_light_collision.get_node("AttackLightHitBox").disabled = false
	
	# turn the hitbox off at and after frame 4
	if state_machine.animated_sprite_2d.get_frame() >= 4:
		attack_light_collision.get_node("AttackLightHitBox").disabled = true
		
	# Attack Light is repeatable up to 3 times (might be up to 4 times...)
	if Input.is_action_just_pressed("attack_light") && attack_light_repeat_count <= 3:
		# Reset the animation
		state_machine.animated_sprite_2d.set_frame(0)
		# Transition to AttackLight
		state_machine.transition_to("AttackLight")
		# Increase your attack_light_repeat_count to keep track of how many times
		#   you've repeated your light attack
		attack_light_repeat_count += 1
		# debug print
		print("attack_light: repeated attack")
		if attack_light_repeat_count == 3:
			print("attack_light: reached maximum number of lights, wait till animation end")
			
	#attack_light_collision.get_node("AttackLightHitBox").disabled = false
	#print("attack_light: hitbox is disabled? " + str(attack_light_collision.get_node("AttackLightHitBox").disabled))
	#print("attack_light: frame number is " + str(state_machine.animated_sprite_2d.get_frame()))

	#print("attack_light: hitbox is disabled? " + str(attack_light_collision.get_node("AttackLightHitBox").disabled))

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
		
	
func exit() -> void:
	pass	
		
		

# Works so far, need to handle repeated attacks when the collision is already
#   inside the given body
func _on_attack_light_collision_body_entered(body):
	if state_machine.animated_sprite_2d.get_animation() == "attack_light":
		if body.is_in_group("debug_enemies"):
			#print("attack_light: dummy enemy is blocking " + str(body.is_dummy_blocking))
			print("attack_light: The opponent is blocking: " + str(owner.dummy_enemy_reference.is_dummy_blocking))
			if owner.dummy_enemy_reference.is_dummy_blocking:
				print("attack_light: light attack collided with debug_enemeies member, but they blocked")
				# send block signal
				light_attack_blocked.emit(ATTACK_LIGHT_PUSHBACK, ATTACK_LIGHT_BLOCK_PUSHBACK)
			else:
				print("attack_light: light attack collided with debug_enemies member")
				# send attack signal
				light_attack_hit.emit(ATTACK_LIGHT_DAMAGE, ATTACK_LIGHT_PUSHBACK)
				
			# This is good, still need to connect these signals to the dummy_enemy script
			#   so that it's properly referenced
			# how do I do this? Probably have to do it manually with the connect() function
			#   hopefully I can use the editor...
