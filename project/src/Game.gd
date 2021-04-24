extends Node

signal score_changed(player, points, new_score)

const WIDTH  := 15
const HEIGHT := 14
const TILE_WIDTH := 64
const TILE_HEIGHT := 64
const TILE_SIZE := Vector2(TILE_WIDTH, TILE_HEIGHT)

var _scores : Array = [0, 0]

# Reset all the state variables
func start():
	_scores = [0, 0]
	

func add_points(player:int, points:int):
	if points != 0:
		_scores[player] += points
		emit_signal("score_changed", player, points, _scores[player])


func get_score(player:int)->int:
	return _scores[player]


func form_action_prefix(index:int)->String:
	return "p%d_" % (index+1)
