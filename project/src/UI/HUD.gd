extends Control

var level : Level setget _set_level

onready var _score_labels := [$HBoxContainer/Player1Score, $HBoxContainer/Player2Score]
onready var _time_left_label := $HBoxContainer/TimeLeft

func _ready():
	Game.connect("score_changed", self, "_on_score_changed")
	for i in range(0, _score_labels.size()):
		_score_labels[i].text = str(Game.get_score(i))


func _process(_delta):
	_time_left_label.text = str(int(ceil(level.get_seconds_remaining())))


func _on_score_changed(player:int, _points:int, score:int):
	var label : Label = _score_labels[player]
	label.text = str(score)


func _set_level(value:Level)->void:
	assert(value!=null)
	level = value
	
