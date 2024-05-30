extends CharacterBody2D

const MAX_HEALTH: int = 100			# Is an int




# References to Player1
@onready var player_1_reference = $"../Player1"
# References attatched to the dummy_enemy
@onready var dummy_animated_sprite_2d = $AnimatedSprite2D
@onready var is_dummy_blocking: bool = false
@onready var dummy_enemy_health_bar = $"../DummyEnemyHealthBar"


var current_health = MAX_HEALTH
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var debug_player_pos
var debug_dummy_pos
var is_alive: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the dummy enemy's health
	dummy_enemy_health_bar.init_health(MAX_HEALTH)

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
	

