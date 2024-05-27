extends CharacterBody2D

const MAX_HEALTH: int = 100			# Is an int
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const JUMP_IMPULSE = 450.0


# Reference to the dummy_enemy. Eventually this would be the other player,
#   but I'm not sure -- it would depend on how I implemented 2 players
# Probably need to rename Player1 to player as well?
@onready var dummy_enemy_reference = $"../DummyEnemy"


@onready var current_health = MAX_HEALTH

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")






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
