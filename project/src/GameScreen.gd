extends Control


func _ready():
	_connect_signals_to($Level)
	
	
func _connect_signals_to(level)->void:
	level.connect("complete", self, "_on_Level_complete")
	level.connect("game_over", self, "_on_game_over")


func _on_Level_complete():
	var message := preload("res://src/UI/LevelCompletePopup.tscn").instance()
	add_child(message)
	get_tree().paused = true
	yield(message, "done")
	remove_child(message)
	
	var new_level : Node2D = load("res://src/Level.tscn").instance()
	new_level.position = $Level.position
	remove_child($Level)
	new_level.name = "Level"
	add_child(new_level)
	
	get_tree().paused = false
	

func _on_game_over():
	get_tree().paused = true
	print("GAME IS OVER")
