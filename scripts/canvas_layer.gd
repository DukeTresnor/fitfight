extends CanvasLayer


const PLAYER_1_HEALTH_BAR_X_OFFSET: float = 15.0
const PLAYER_1_HEALTH_BAR_Y_OFFSET: float = 20.0
const PLAYER_1_HEALTH_BAR_X_SCALE_FACTOR: float = 2.0
const PLAYER_1_HEALTH_BAR_Y_SCALE_FACTOR: float = 2.0

const PLAYER_2_HEALTH_BAR_X_OFFSET: float = 15.0
const PLAYER_2_HEALTH_BAR_Y_OFFSET: float = 20.0
const PLAYER_2_HEALTH_BAR_X_SCALE_FACTOR: float = 2.0
const PLAYER_2_HEALTH_BAR_Y_SCALE_FACTOR: float = -2.0

# At on ready variables
@onready var camera_2d = $"../Camera2D"

@onready var player_1_health_bar = $Player1HealthBar
@onready var dummy_enemy_health_bar = $DummyEnemyHealthBar



# Regular (environment?) variables
var viewport_coord_x
var viewport_coord_y

var target_player_1_health_bar_coord_x
var target_player_1_health_bar_coord_y

var target_player_2_health_bar_coord_x
var target_player_2_health_bar_coord_y

var target_player_1_health_position: Vector2
var target_player_2_health_position: Vector2

var target_player_1_health_scale: Vector2
var target_player_2_health_scale: Vector2


func _ready():
	pass

func _process(delta):
	'''
	
	print("camera_2d: player halth bar location: " + str(player_1_health_bar.global_position))
	print("camera_2d: camera_2d's screen center: " + str(self.get_viewport_rect().size / 2) )
	print("camera_2d: dummy_enemy_health_bar location: " + str(dummy_enemy_health_bar.global_position))

	var testing_pos_x = self.get_viewport_rect().size.x / 2
	var testing_pos_y = self.get_viewport_rect().size.y / 2

	viewport_coord_x = self.get_viewport().size.x / 2
	viewport_coord_y = self.get_viewport().size.y / 2
	
	target_player_1_health_bar_coord_x = viewport_coord_x - viewport_coord_x
	target_player_1_health_bar_coord_y = viewport_coord_y

	#var testing_healt_pos: Vector2 = Vector2(50.0, -208)
	var testing_healt_pos: Vector2 = Vector2(target_player_1_health_bar_coord_x, \
											target_player_1_health_bar_coord_y)

	player_1_health_bar.set_global_position(testing_healt_pos)
	'''
	viewport_coord_x = camera_2d.get_viewport_rect().size.x / 2
	viewport_coord_y = camera_2d.get_viewport_rect().size.y / 2
	
	target_player_1_health_bar_coord_x = viewport_coord_x - viewport_coord_x + PLAYER_1_HEALTH_BAR_X_OFFSET
	target_player_1_health_bar_coord_y = viewport_coord_y - viewport_coord_y + PLAYER_1_HEALTH_BAR_Y_OFFSET
	
	target_player_2_health_bar_coord_x = viewport_coord_x + viewport_coord_x - PLAYER_2_HEALTH_BAR_X_OFFSET
	target_player_2_health_bar_coord_y = viewport_coord_y - viewport_coord_y + PLAYER_2_HEALTH_BAR_Y_OFFSET	
	
	target_player_1_health_position = Vector2( \
			target_player_1_health_bar_coord_x, \
			target_player_1_health_bar_coord_y)

	target_player_1_health_scale = Vector2(PLAYER_1_HEALTH_BAR_X_SCALE_FACTOR, \
				PLAYER_1_HEALTH_BAR_Y_SCALE_FACTOR)

	target_player_2_health_position = Vector2( \
			target_player_2_health_bar_coord_x, \
			target_player_2_health_bar_coord_y)

	target_player_2_health_scale = Vector2(PLAYER_2_HEALTH_BAR_X_SCALE_FACTOR, \
				PLAYER_2_HEALTH_BAR_Y_SCALE_FACTOR)

	player_1_health_bar.set_global_position(target_player_1_health_position)
	player_1_health_bar.set_scale(target_player_1_health_scale)

	# Using dummy health bar reference for now!
	#player_2_health_bar.set_global_position(target_player_2_health_position)
	#player_2_health_bar.set_scale(target_player_2_health_scale)
	dummy_enemy_health_bar.set_global_position(target_player_2_health_position)
	dummy_enemy_health_bar.set_scale(target_player_2_health_scale)
	dummy_enemy_health_bar.rotation = -PI
