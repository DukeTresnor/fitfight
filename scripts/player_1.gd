extends CharacterBody2D

signal attack_collision(attack_damage, attack_pushback, attack_hitstun, \
						attack_block_pushback, attack_blockstun)

const MAX_HEALTH: int = 100			# Is an int
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_IMPULSE = 450.0


# Reference to the dummy_enemy. Eventually this would be the other player,
#   but I'm not sure -- it would depend on how I implemented 2 players
# Probably need to rename Player1 to player as well?
@onready var dummy_enemy_reference = $"../DummyEnemy"

@onready var current_health = MAX_HEALTH

# Reference to the Player1HealthBar
@onready var player_1_health_bar = $"../Player1HealthBar"


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






func _on_attack_light_light_attack_hit(attack_light_damage, attack_light_pushback, \
									attack_light_hitstun, attack_light_block_pushback, \
									attack_light_blockstun):
#signal light_attack_hit(light_attack_damage, light_attack_pushback, attack_light_hitstun,
#attack_light_block_pushback, attack_light_blockstun)
	attack_collision.emit(attack_light_damage, attack_light_pushback, attack_light_hitstun, \
							attack_light_block_pushback, attack_light_blockstun)
