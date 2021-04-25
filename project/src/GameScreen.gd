extends Control

func _ready():
	_connect_signals_to($Level)
	$HUD.level = $Level
	
	
func _connect_signals_to(level)->void:
	level.connect("complete", self, "_on_Level_complete")
	level.connect("game_over", self, "_on_game_over")


func _on_Level_complete():
	_show_end_control("Level Complete", "_on_EndControl_done_complete")
	
	
func _show_end_control(text:String, callback:String)->void:
	var message := preload("res://src/UI/EndControl.tscn").instance()
	message.text = text
	add_child(message)
	message.connect("done", self, callback, [message], CONNECT_ONESHOT)
	get_tree().paused = true


func _on_EndControl_done_complete(message:Control):
	remove_child(message)
	
	# Replace completed level with a new level
	var new_level : Node2D = load("res://src/Level.tscn").instance()
	new_level.position = $Level.position
	remove_child($Level)
	new_level.name = "Level"
	_connect_signals_to(new_level)
	add_child(new_level)
	
	get_tree().paused = false


func _on_game_over():
	_show_end_control("Game Over!", "_on_EndControl_done_gameover")
	

func _on_EndControl_done_gameover(_message:Control)->void:
	get_tree().paused = false
	get_tree().change_scene("res://src/Screens/TitleScreen.tscn")
	
