extends CharacterBody2D


signal dummy_attack_hit(attack_damage, attack_pushback, attack_hitstun, \
						attack_block_pushback, attack_blockstun)


const MAX_HEALTH: int = 100			# Is an int

# Dummy attack constants
const dummy_attack_damage: int = 5
const dummy_attack_pushback: int = 1
const dummy_attack_hitstun: int = 200
const dummy_attack_block_pushback: int = 1
const dummy_attack_blockstun: int = 10



# References to Player1
@onready var player_1_reference = $"../Player1"
# References attatched to the dummy_enemy
@onready var dummy_animated_sprite_2d = $AnimatedSprite2D
@onready var is_dummy_blocking: bool = false
@onready var dummy_enemy_health_bar = $"../DummyEnemyHealthBar"
@onready var dummy_box_collision = $DummyBoxCollision




var current_health = MAX_HEALTH
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var debug_player_pos
var debug_dummy_pos
var is_alive: bool = true




# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the dummy enemy's health
	dummy_enemy_health_bar.init_health(MAX_HEALTH)

# This is the dummy version for update? not quite sure difference between update
#   and process at the moment
func _process(delta):
	#dummy_animated_sprite_2d.play(("debug_idle"))

	

	# [ ---------------------------------------------
	# Directional Blocking code block for dummy enemy
	# Implement something similar with the player,
	#   then make it standardized using state transitions
	debug_player_pos = player_1_reference.global_position
	debug_dummy_pos = dummy_animated_sprite_2d.global_position
	#print("dummy_enemy: distance between players: " + str(debug_player_pos - debug_dummy_pos))
	
	if ((debug_player_pos - debug_dummy_pos) >= Vector2(0.0, 0.0) && Input.is_action_pressed("debug_dummy_move_left")) || \
		((debug_player_pos - debug_dummy_pos) < Vector2(0.0, 0.0) && Input.is_action_pressed("debug_dummy_move_right")) \
		&& not (Input.is_action_pressed("debug_dummy_move_left") && Input.is_action_pressed("debug_dummy_move_right")):
		#dummy_animated_sprite_2d.play("debug_block")
		is_dummy_blocking = true
	else:
		#dummy_animated_sprite_2d.play(("debug_idle"))
		is_dummy_blocking = false
		
	# --------------------------------------------- ]

	# [ ---------------------------------------------
	# Attack code block for dummy enemy
	if Input.is_action_just_pressed("debug_dummy_attack"):
		# Play debug_attack animation
		dummy_animated_sprite_2d.play("debug_attack")
		
		# Turn on hitboxes
		dummy_box_collision.get_node("DummyHitBox").disabled = false
		dummy_box_collision.get_node("DummyHurtBox").disabled = false
		
		#pass
	# --------------------------------------------- ]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	# Not the solution to switching left or right based on player distance
	# But setting up the reference works!
	#look_at(player_1_reference.global_position)



#	attack_collision.emit(attack_light_damage, attack_light_pushback,
#attack_light_hitstun, \
#							attack_light_block_pushback, attack_light_blockstun)


func _set_health(value):
	# Set the HealthBar to the value parameter
	dummy_enemy_health_bar._set_health(value)
	# Adjust the internal health for the DummyEnemy to the value parameter
	current_health = value
	
	if current_health <= 0 && is_alive:
		print("dummy_enemy: current_health below 0, kill the DummyEnemy")
		print("dummy_enemy: current_health: " + str(current_health))
		# Signal to kill player? Run ending sequence?

		# set is_alive to false
		is_alive = false

func _on_player_1_attack_collision(attack_damage, attack_pushback, attack_hitstun, \
									attack_block_pushback, attack_blockstun):


	if is_dummy_blocking:	
		dummy_animated_sprite_2d.play("debug_block")
		print("dummy_enemy: I blocked. I got pushed back " + str(attack_block_pushback) \
				+ " units")
		print("dummy_enemy: I'm in hitstun for " + str(attack_blockstun) + " frames")
	else:
		dummy_animated_sprite_2d.play("debug_hit")
		print("dummy_enemy: I got hit! I took " + str(attack_damage) + " damage")
		print("dummy_enemy: I got pushed back " + str(attack_pushback) + " units")
		print("dummy_enemy: I'm in hitstun for " + str(attack_hitstun) + " frames")
		
		# change health here? or send a signal
		dummy_enemy_health_bar._set_health(dummy_enemy_health_bar.health - attack_damage)




# function that's called when dummy attack animation finishes
func _on_animated_sprite_2d_animation_finished():
	
	# Check if the animation that finished was the dummy_attack animation
	if dummy_animated_sprite_2d.get_animation() == "debug_attack":
		# Disable the dummy attack hit and hurtboxes
		dummy_box_collision.get_node("DummyHitBox").disabled = true
		dummy_box_collision.get_node("DummyHurtBox").disabled = true
		
		# Return to the debug idle animation
		dummy_animated_sprite_2d.play("debug_idle")
				
		#pass
	
	# Check if the animation is debug_hit
	if (dummy_animated_sprite_2d.get_animation() == "debug_hit" || \
		dummy_animated_sprite_2d.get_animation() == "debug_block"):
		
		dummy_animated_sprite_2d.play("debug_idle")
		

# Because I'm not using a state machine for the dummy enemy, I can send this directly
#   to the player
#   When I implement this with 2 players, I need to have the full structure
func _on_dummy_box_collision_body_entered(body):
	if dummy_animated_sprite_2d.get_animation() == "debug_attack":
		if body.is_in_group("player_1"):
			print("dummy_enemy: body collision with: " + str(body))
			
			dummy_attack_hit.emit(dummy_attack_damage, dummy_attack_pushback, \
								dummy_attack_hitstun, dummy_attack_block_pushback, \
								dummy_attack_blockstun)


