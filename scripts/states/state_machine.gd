# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
# This was originally export as a keyword, but now export
#   is an annotation
@export var initial_state := NodePath()

# The current active state. At the start of the game, we get the `initial_state`.
# The get_node() function takes a NodePath() object
@onready var state: State = get_node(initial_state)
#@onready var state = get_node(initial_state)

@onready var animated_sprite_2d = $"../AnimatedSprite2D"

# This isn't used, edit out later
#@onready var animation_player = $"../AnimationPlayer"




func _ready() -> void:
	#yield(owner, "ready")
	await owner.ready

	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		if child is State:
			child.state_machine = self
		
	# This call doesn't work, getting a Null error	
	# Setting up an enemy on startup. With two players this should do something
	#   with the server that is hosting each player but I'm not sure how to do that yet
	#dummy_enemy.add_to_group("DebugEnemy")

	state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	#state = $target_state_name
	state.enter(msg)
	emit_signal("transitioned", state.name)
	
	# Debug
	#print("state_machine: I transitioned to " + target_state_name)
