extends Node

const TWEEN_SPEED = 1.5

var p1respawn = Vector2(0, 0)
var p2respawn = Vector2(0, 0)

var game_started = false

onready var TRANSITION_NODE = $CanvasLayer/Transition
onready var TITLE_SCREEN = $CanvasLayer/TitleScreen
onready var MUSIC = $AudioStreamPlayer

onready var players := {
	"1": {
		viewport = $"VBoxContainer/ViewportContainer/Viewport",
		camera = $"VBoxContainer/ViewportContainer/Viewport/Camera2D",
		player = $VBoxContainer/ViewportContainer/Viewport/LevelManager/TestLevel/Player1,
	},
	"2": {
		viewport = $"VBoxContainer/ViewportContainer2/Viewport",
		camera = $"VBoxContainer/ViewportContainer2/Viewport/Camera2D",
		player = $VBoxContainer/ViewportContainer/Viewport/LevelManager/TestLevel/Player2,
	},
}

func _ready():
	Global.set_game_node(self)
	camera_init()
	pass

func _process(_delta):
	if MUSIC.is_playing() == false && game_started:
		MUSIC.play()


func start_game():
	# Animate the transition
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(TRANSITION_NODE.material, 'shader_param/cutoff', 0.0, TWEEN_SPEED)
	yield(tween, "finished")
	TITLE_SCREEN.hide()
	game_started = true
	Global.start_timer()
	var tween2 := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween2.tween_property(TRANSITION_NODE.material, 'shader_param/cutoff', 1.0, TWEEN_SPEED)
	yield(tween2, "finished")
	

	

func camera_init():
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)

func update_respawn_points(p1, p2):
	print("Updating respawn points: ", p1, p2)
	p1respawn = p1
	p2respawn = p2

func respawn_players():
	players["1"].player.global_position = p1respawn
	players["2"].player.global_position = p2respawn
