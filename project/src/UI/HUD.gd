extends Control

onready var _score_labels := [$HBoxContainer/Player1Score, $HBoxContainer/Player2Score]


func _ready():
	Game.connect("score_changed", self, "_on_score_changed")
	for i in range(0, _score_labels.size()):
		_score_labels[i].text = str(Game.get_score(i))


func _on_score_changed(player:int, _points:int, score:int):
	var label : Label = _score_labels[player]
	label.text = str(score)
