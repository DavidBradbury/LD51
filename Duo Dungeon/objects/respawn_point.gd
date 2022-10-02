extends Node2D

onready var p1point = $Player1Point
onready var p2point = $Player2Point

func _on_Area2D_body_entered(body:Node):
	Global.update_respawn_points(p1point.global_position, p2point.global_position)
	pass
