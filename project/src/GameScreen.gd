extends Control


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
	new_level.connect("complete", self, "_on_Level_complete")
	add_child(new_level)
	
	get_tree().paused = false
	
