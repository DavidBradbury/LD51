extends Node2D
onready var animation_player = $AnimationPlayer

var open = false
var b1active = false
var b2active = false

func _on_Area2D2_body_entered(_body:Node):
	if open == false:
		b1active = true
		animation_player.play("ButtonDown")
		yield(animation_player, "animation_finished")
		check_buttons()

func _on_Area2D_body_entered(body:Node):
	if open == false:
		b2active = true
		animation_player.play("ButtonDown2")
		yield(animation_player, "animation_finished")
		check_buttons()


func _on_Area2D2_body_exited(body:Node):
	if open == false:
		b1active = false
		animation_player.play("ButtonUp")
		yield(animation_player, "animation_finished")
		check_buttons()


func _on_Area2D_body_exited(body:Node):
	if open == false:
		b2active = false
		animation_player.play("ButtonUp2")
		yield(animation_player, "animation_finished")
		check_buttons()


func check_buttons():
	if b1active == true and b2active == true:
		animation_player.play("Activate")
		open = true
