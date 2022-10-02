extends Button

func _on_Button_pressed():
	# Quit the game
	get_tree().quit()

# Connect to button pressed signal and run the game.start_game function
func _ready():
	self.connect("pressed", self, "_on_Button_pressed")
