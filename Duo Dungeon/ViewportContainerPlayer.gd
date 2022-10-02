# warning-ignore-all:return_value_discarded
extends ViewportContainer
class_name ViewportContainerPlayer

export(int) var PLAYER_NUMBER = 1
export(float) var TWEEN_SPEED = 0.5

func _ready():
	Global.connect("current_player_changed", self, "on_current_player_changed")
	if Global.current_player != null:
		on_current_player_changed(Global.current_player)

func on_current_player_changed(player):
	print("Current player changed to: " + str(player))
	var tween := create_tween()
	if player == PLAYER_NUMBER:
		tween.tween_property(self.material, 'shader_param/playerState', 0.0, TWEEN_SPEED)
	else:
		tween.tween_property(self.material, 'shader_param/playerState', 1.0, TWEEN_SPEED)
