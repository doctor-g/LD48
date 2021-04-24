extends Control


func _on_Button_pressed():
	Game.start()
	get_tree().change_scene("res://src/GameScreen.tscn")
