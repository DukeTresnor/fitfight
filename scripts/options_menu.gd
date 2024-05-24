extends Control


# Connected to the OptionsMenu scene
func _on_back_pressed():
	# Change scene back to the main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
