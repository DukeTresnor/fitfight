extends CharacterBody2D

# General logic for collisions is within the AttackX script, is a signal tied to that
#   script. This signal is attached to the player_1 script, which in turn has a signal
#   called attack_collision. This signal is sent to the opposing player / dummy enemy
signal attack_collision(attack_damage, attack_pushback, attack_hitstun, \
						attack_block_pushback, attack_blockstun)


# This signal is for when the player inside the game scene receives a signal 
#   from the opposing player / enemy that one of their collishion 2d nodes collided
#   with this player's collisions 
signal enemy_attack_collision(attack_damage, attack_pushback, attack_hitstun, \
						attack_block_pushback, attack_blockstun)


const MAX_HEALTH: int = 100			# Is an int
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_IMPULSE = 450.0


# Reference to the dummy_enemy. Eventually this would be the other player,
#   but I'm not sure -- it would depend on how I implemented 2 players
# Probably need to rename Player1 to player as well?
@onready var dummy_enemy_reference = $"../DummyEnemy"
# This above should eventually be player_2_reference

@onready var current_health = MAX_HEALTH

# Reference to the Player1HealthBar
# Needs to be adjusted if I adjust the parents / children of the player's
#   health bar
@onready var player_1_health_bar = $"../Player1HealthBar"
#@onready var player_1_health_bar = $"../CanvasLayer/Player1HealthBar"

# Reference to the player's animated sprite 2d node, to determine if the player
#   is blocking
@onready var animated_sprite_2d = $AnimatedSprite2D


var player_pos
var enemy_pos
var is_player_1_blocking: bool = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Player1 is alive
var is_alive: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize player_1's health
	player_1_health_bar.init_health(MAX_HEALTH)
	



func _set_health(value):
	# Set the HealthBar to the value parameter
	player_1_health_bar._set_health(value)
	# Adjust the internal health for the DummyEnemy to the value parameter
	current_health = value
	
	if current_health <= 0 && is_alive:
		print("player_1: current_health below 0, kill Player1")
		print("player_1: current_health: " + str(current_health))
		# Signal to kill player? Run ending sequence?

		# set is_alive to false
		is_alive = false

func update(delta: float) -> void:
	'''
	player_pos = animated_sprite_2d.global_position
	enemy_pos = dummy_enemy_reference.global_position

	# [ ---------------------------------------------
	# Directional Blocking code block for player_1
	if ((player_pos - enemy_pos) >= Vector2(0.0, 0.0) && Input.is_action_pressed("move_right")) || \
		((player_pos - enemy_pos) < Vector2(0.0, 0.0) && Input.is_action_pressed("move_left")) \
		&& not (Input.is_action_pressed("move_left") && Input.is_action_pressed("move_right")):
		is_player_1_blocking = true
	else:
		is_player_1_blocking = false
			
	print("player_1: is_player_1_blocking: " + str(is_player_1_blocking))
	# --------------------------------------------- ]
	'''
	pass
	



#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump_neutral") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("move_left", "move_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()





# This is the player hitting the enemy with light attack
func _on_attack_light_light_attack_hit(attack_light_damage, attack_light_pushback, \
									attack_light_hitstun, attack_light_block_pushback, \
									attack_light_blockstun):
#signal light_attack_hit(light_attack_damage, light_attack_pushback, attack_light_hitstun,
#attack_light_block_pushback, attack_light_blockstun)
	attack_collision.emit(attack_light_damage, attack_light_pushback, attack_light_hitstun, \
							attack_light_block_pushback, attack_light_blockstun)


# This is when the enemy (player 2) hits the player (player 1)
#   ie whenever player 2 hits player 1 with a hitbox
# With a player_2, this should be ...
# func _on_player_2_attack_collision(signal parameters)
func _on_dummy_enemy_dummy_attack_hit(attack_damage, attack_pushback, attack_hitstun, attack_block_pushback, attack_blockstun):
	
	#print("player_1: dummy attack is hitting player_1")
	#enemy_attack_collision.emit(attack_damage, attack_pushback, attack_hitstun, \
	#						attack_block_pushback, attack_blockstun)
							
	# I want to modify this function to call every node in the state machine, 
	#   not just emit a signal for Idle to recognize
	#   I can try to use groups
	#     In the state_machine_nodes group, I have Idle, Walk, Jump, Crouch,
	#       and AttackLight
	#print_tree()
	# Replace "junk_virtual" with your desired function to call each state in the state
	#   group
	# Add arguments to the junk_virtual function as additional params to this
	#   call_group() function
	
	
	
	# Get the group state_machine_nodes that exist in the current tree, 
	#   and for each node call its collision_check() function if it has one
	get_tree().call_group("state_machine_nodes", "collision_check", \
							attack_damage, attack_pushback, attack_hitstun, \
							attack_block_pushback, attack_blockstun)
	

	
	
	# One alternative option is to just have an "enemy_attack_collision" signal for
	#   each of the player's states
	#   Ie something like enemy_attack_collision_in_idle, enemy_attack_collision_in_crouch
	#     enemy_attack_collision_in_jump, etc.
	#   There could be some sort of checker within this function too...
	#     Ie if player state is idle, enemy_attack_collision_in_idle.emit(),
	#       if player state is crouch, enemy_attack_collision_in_crouch.emit(), etc.
	#   This would use a match against the player's current state
	#     Does this script even have access to the state machine?


# Function block for taking damage signals
# [ ---------------------------------------------------------------------
func _on_idle_took_damage_in_idle(damage):
	print("player_1: I took " + str(damage) + " damage when in idle")
	#owner.player_1_health_bar._set_health(owner.player_1_health_bar.health - attack_damage)
	player_1_health_bar._set_health(player_1_health_bar.health - damage)

func _on_walk_took_damage_in_walk(damage):
	print("player_1: I took " + str(damage) + " damage when in walk")
	#owner.player_1_health_bar._set_health(owner.player_1_health_bar.health - attack_damage)
	player_1_health_bar._set_health(player_1_health_bar.health - damage)

func _on_jump_took_damage_in_jump(damage):
	print("player_1: I took " + str(damage) + " damage when in jump")
	#owner.player_1_health_bar._set_health(owner.player_1_health_bar.health - attack_damage)
	player_1_health_bar._set_health(player_1_health_bar.health - damage)

func _on_crouch_took_damage_in_crouch(damage):
	print("player_1: I took " + str(damage) + " damage when in crouch")
	#owner.player_1_health_bar._set_health(owner.player_1_health_bar.health - attack_damage)
	player_1_health_bar._set_health(player_1_health_bar.health - damage)

func _on_attack_light_took_damage_in_attack_light(damage):
	print("player_1: I took " + str(damage) + " damage when in attack_light")
	#owner.player_1_health_bar._set_health(owner.player_1_health_bar.health - attack_damage)
	player_1_health_bar._set_health(player_1_health_bar.health - damage)
	
# Each new state (attack or otherwise) should have an equivalent connected
#   function here
# --------------------------------------------------------------------- ]
