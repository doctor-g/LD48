extends Control

var clicks_remaining := 2

func _on_ClickinLabel_done():
	clicks_remaining -= 1
	if clicks_remaining <= 0:
		Game.start()
		get_tree().change_scene("res://src/GameScreen.tscn")
