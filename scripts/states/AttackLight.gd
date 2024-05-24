extends State

# References to player_1's various hitboxes
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
	#attack_light_collision.get_node("AttackLightHitBox").disabled = false
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
			print("attack_light: light attack collided with debug_enemies member")
