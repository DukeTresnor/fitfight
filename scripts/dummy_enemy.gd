extends CharacterBody2D

const MAX_HEALTH: int = 100			# Is an int


var current_health = MAX_HEALTH

# Reference to Player1
@onready var player_1_reference = $"../Player1"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	# Not the solution to switching left or right based on player distance
	# But setting up the reference works!
	#look_at(player_1_reference.global_position)
