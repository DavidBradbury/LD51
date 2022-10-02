extends Button

func _on_Button_pressed():
	Global.start_game()

# Connect to button pressed signal and run the game.start_game function
func _ready():
	self.grab_focus()
	self.connect("pressed", self, "_on_Button_pressed")
