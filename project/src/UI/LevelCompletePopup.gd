extends Control

signal done

var _countdown := 2


func _on_ClickinLabel_done():
	_countdown -= 1
	if _countdown == 0:
		emit_signal("done")
