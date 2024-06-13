extends Camera2D


const ZOOM_FACTOR_X_ADJUSTMENT: int = 600
const ZOOM_FACTOR_Y_ADJUSTMENT: int = 500
const MAX_ZOOM: float = 0.4


@onready var player_1 = $"../Player1"
# Replace with reference to player 2
@onready var dummy_enemy = $"../DummyEnemy"


@onready var player_1_health_bar = $"../Player1HealthBar"
#@onready var player_1_health_bar = $"../CanvasLayer/Player1HealthBar"


var zoom_factor_x
var zoom_factor_y
var zoom_factor_main



func _ready():
	pass
	
func _process(delta):
	#print("camera_2D: player_1 global position: " + str(player_1.global_position))
	#print("camera_2D: player_2 global position: " + str(player_2.global_position))	

	# The global position of the camera is set to the average of the players' global positions
	self.global_position = (player_1.global_position + dummy_enemy.global_position) * 0.5
	print("camera_2D: camera global position: " + str(self.global_position))

	# Zoom adjustment block
	# has the opposite behavior that i want
	# as players increase distance, zoom increases -> it should decrease
	zoom_factor_x = abs(player_1.global_position.x - dummy_enemy.global_position.x) / ZOOM_FACTOR_X_ADJUSTMENT
	zoom_factor_y = abs(player_1.global_position.y - dummy_enemy.global_position.y) / ZOOM_FACTOR_Y_ADJUSTMENT 
	zoom_factor_main = max(max(zoom_factor_x, zoom_factor_y), MAX_ZOOM)
	
	# Debug for the camera
	#print("camera_2d: zoom_factor_x: " + str(zoom_factor_x))
	#print("camera_2d: zoom_factor_y: " + str(zoom_factor_y))
	#print("camera_2s: zoom_factor_main: " +str(zoom_factor_main))
	
	self.zoom = Vector2(1.0/zoom_factor_main, 1.0/zoom_factor_main)
	

	print("camera_2d: player halth bar location: " + str(player_1_health_bar.global_position))
	print("camera_2d: camera_2d's screen center: " + str(self.get_viewport_rect().size / 2) )

	var testing_pos_x = self.get_viewport_rect().size.x / 2
	var testing_pos_y = self.get_viewport_rect().size.y / 2



	#player_1_health_bar.global_position = self.get_viewport_rect().size / 2
	print("skjnvkdjfnjkdnvkdfn " + str(testing_pos_x))
	#player_1_health_bar.global_position = Vector2(testing_pos_x, player_1_health_bar.global_position.y)
	#player_1_health_bar.global_position = Vector2(testing_pos_x, testing_pos_y)
	#player_1_health_bar.global_position = self.global_position
