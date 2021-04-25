extends Label

signal done

export var pre_text := "Click In!"
export var post_text := "Ready!"
export var index := 0

var done := false

var _prefix : String

func _ready():
	text = pre_text


func _unhandled_input(event):
	if not done:
		if event.is_action_released(Game.form_action_prefix(index) + "fire"):
			$ClickinSound.play()
			done = true
			text = post_text
			


func _on_ClickinSound_finished():
	emit_signal("done")
