extends Control

signal done

export var text := "Level Complete" setget _set_text

var _countdown := 2


func _on_ClickinLabel_done():
	_countdown -= 1
	if _countdown == 0:
		emit_signal("done")


func _set_text(new_text:String):
	text = new_text
	$VBoxContainer/Label.text = text
