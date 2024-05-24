extends Control


# vs button is connected with MainMenu
func _on_vs_pressed():
	# Gets the current tree and changes the scene to the game scene using its
	#   file
	get_tree().change_scene_to_file("res://scenes/game.tscn")


# options button is connected with MainMenu
func _on_options_pressed():
	# Change to the OptionsMenu scene
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")

# exit button is connected with MainMenu
func _on_exit_pressed():
	# Gets the current tree and quits out of the executable
	get_tree().quit()
