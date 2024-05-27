extends CharacterBody2D

const MAX_HEALTH: int = 100			# Is an int


var current_health = MAX_HEALTH

# References to Player1
@onready var player_1_reference = $"../Player1"



# References attatched to the dummy_enemy
@onready var dummy_animated_sprite_2d = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")




@onready var is_dummy_blocking: bool = false

var debug_player_pos
var debug_dummy_pos


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	# If you are holding a specific button, make dummy play block animation
	#print("dummy_enemy: The dummy is blocking: " + str(is_dummy_blocking))
	
	# [ ---------------------------------------------
	# Directional Blocking code block for dummy enemy
	# Implement something similar with the player,
	#   then make it standardized using state transitions
	debug_player_pos = player_1_reference.global_position
	debug_dummy_pos = dummy_animated_sprite_2d.global_position
	#print("dummy_enemy: distance between players: " + str(debug_player_pos - debug_dummy_pos))
	

	
	# Not sure of the last clause to catch holding left and right
	#   If you hold left and right stop blocking is the desired behavior
	#   Might be able to do it by checking if you're holding towards the opponent or not...
	# Right now I should be only running this code when the dummy player receives a signal that
	#   its hurtbox was collided with
	#   other option is to just check if the dummy enemy's collision box has been entered
	#     then it's up to the other player's scripts to determine other effects?
	#     no, I think this only works if I have an area2d node to pull a signal from?
	if ((debug_player_pos - debug_dummy_pos) >= Vector2(0.0, 0.0) && Input.is_action_pressed("debug_dummy_move_left")) || \
		((debug_player_pos - debug_dummy_pos) < Vector2(0.0, 0.0) && Input.is_action_pressed("debug_dummy_move_right")) \
		&& not (Input.is_action_pressed("debug_dummy_move_left") && Input.is_action_pressed("debug_dummy_move_right")):
		dummy_animated_sprite_2d.play("debug_block")
		is_dummy_blocking = true
	else:
		dummy_animated_sprite_2d.play(("debug_idle"))
		is_dummy_blocking = false
	# --------------------------------------------- ]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	# Not the solution to switching left or right based on player distance
	# But setting up the reference works!
	#look_at(player_1_reference.global_position)



