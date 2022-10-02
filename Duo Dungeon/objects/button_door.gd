extends Node2D
onready var animation_player = $AnimationPlayer

var open = false


func _on_Area2D_body_entered(_body:Node):
	if open == false:
		animation_player.play("ButtonDown")
		yield(animation_player, "animation_finished")
		animation_player.play("DoorOpen")
		open = true
