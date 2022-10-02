# Global singleton for game data and game state
extends Node
signal current_player_changed

const MAX_PLAYERS = 2
const WAIT_TIME = 5.81
var current_player = 1
var timer = Timer.new()
var gameNode = null

# Every 10 seconds the current player is switched by the toggle_current_player() function

# onready
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = WAIT_TIME
	timer.connect("timeout", self, "toggle_current_player")
	print("Game data ready")

func toggle_current_player():
	current_player += 1
	if current_player > MAX_PLAYERS:
		current_player = 1
	emit_signal("current_player_changed", current_player)
	timer.stop()
	timer.start()


func start_timer():
	timer.start()

func set_game_node(node):
	gameNode = node

func respawn_players():
	gameNode.respawn_players()

func update_respawn_points(p1, p2):
	gameNode.update_respawn_points(p1, p2)

func start_game():
	gameNode.start_game()
