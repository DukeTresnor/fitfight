extends ProgressBar

@onready var damage_bar = $DamageBar
@onready var timer = $Timer

# : set = _set_health is the special syntax to create a setter or getter function
var health = 0 : set = _set_health


# Not sure here? trying to fix null reference error...
func _ready():
	damage_bar.max_value = 0


# \/ ??
# A function that matches the value for the set declaration needs to be declared as well
func _set_health(new_health):
	
	
	# store previous health
	# var old_var = things
	var previous_health = health
	# get the new health, making sure that it isn't above the max health
	
	health = min(max_value, new_health)
	# set HealthBar's value parameter to our new health
	value = health


	# If health goes to 0 or below, despawn the health bar
	# probably don't want this?
	if health <= 0:
		queue_free()
		
	# If our new health is ever below the previous health, start the timer for
	#   the DamageBar to catch up
	if health < previous_health:
		timer.start()
	# Right now there is no healing! >_>
	#else:
	#	# If the new health is above the previous health, we're healing.
	#	#   There shouldn't be any damage bar shown, so just make it the same
	#	#     as the HealthBar
	#	damage_bar.value = health

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

# When the timer on the Timer node finishes (ie on timeout), run this function
#   This should make the DamageBar match the HealthBar
func _on_timer_timeout():
	damage_bar.value = health
