extends Camera2D


const ZOOM_FACTOR_X_ADJUSTMENT: int = 800
const ZOOM_FACTOR_Y_ADJUSTMENT: int = 400
#const ZOOM_FACTOR_Y_ADJUSTMENT: int = 400

# Not sure about this logic, but the values are ok for now
# [---------------------------
# Becomes minimum zoom thanks to inverting the zoom calculation at the
#   end of process()
const MAX_ZOOM: float = 0.4
# Becomes maximum zoom
const MIN_ZOOM: float = 0.75
# ---------------------------]

@onready var player = $"../Player1"
# Replace with reference to player 2
@onready var dummy_enemy = $"../DummyEnemy"


#@onready var player_health_bar = $"../Player1HealthBar"
#@onready var player_health_bar = $"../CanvasLayer/Player1HealthBar"

#@onready var dummy_enemy_health_bar = $"../DummyEnemyHealthBar"

var zoom_factor_x
var zoom_factor_y
var zoom_factor_main

func _ready():
	pass
	
func _process(delta):
	#print("camera_2D: player global position: " + str(player.global_position))
	#print("camera_2D: player_2 global position: " + str(player_2.global_position))	

	# The global position of the camera is set to the average of the players' global positions
	self.global_position = (player.global_position + dummy_enemy.global_position) * 0.5
	#rint("camera_2D: camera global position: " + str(self.global_position))
	

	# Zoom adjustment block
	# has the opposite behavior that i want
	# as players increase distance, zoom increases -> it should decrease
	zoom_factor_x = abs(player.global_position.x - dummy_enemy.global_position.x) / ZOOM_FACTOR_X_ADJUSTMENT
	zoom_factor_y = abs(player.global_position.y - dummy_enemy.global_position.y) / ZOOM_FACTOR_Y_ADJUSTMENT 
	zoom_factor_main = min(max(max(zoom_factor_x, zoom_factor_y), MAX_ZOOM), MIN_ZOOM)
	
	# Debug for the camera
	#print("camera_2d: zoom_factor_x: " + str(zoom_factor_x))
	#print("camera_2d: zoom_factor_y: " + str(zoom_factor_y))
	#print("camera_2s: zoom_factor_main: " +str(zoom_factor_main))
	
	self.zoom = Vector2(1.0/zoom_factor_main, 1.0/zoom_factor_main)
	#self.zoom = Vector2(1.0/zoom_factor_x, 1.0/zoom_factor_y)


	#var testing_pos_x = self.get_viewport_rect().size.x / 2
	#var testing_pos_y = self.get_viewport_rect().size.y / 2

	#viewport_coord_x = self.get_viewport().size.x / 2
	#viewport_coord_y = self.get_viewport().size.y / 2
	
	#target_player_health_bar_coord_x = viewport_coord_x - viewport_coord_x
	#target_player_health_bar_coord_y = viewport_coord_y

	#var testing_healt_pos: Vector2 = Vector2(50.0, -208)
	#var testing_healt_pos: Vector2 = Vector2(target_player_health_bar_coord_x, \
	#										target_player_health_bar_coord_y)

	#player_health_bar.set_global_position(testing_healt_pos)

	#player_health_bar.global_position = self.get_viewport_rect().size / 2
	#print("skjnvkdjfnjkdnvkdfn " + str(testing_pos_x))
	#player_health_bar.global_position = Vector2(testing_pos_x, player_health_bar.global_position.y)
	#player_health_bar.global_position = Vector2(testing_pos_x, testing_pos_y)
	#player_health_bar.global_position = self.global_position
