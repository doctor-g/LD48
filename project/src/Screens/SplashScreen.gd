extends Control

const TITLE = preload("res://src/Screens/TitleScreen.tscn")

# We only need to do the click-through on HTML5.
func _ready():
	randomize()
	if OS.get_name() != "HTML5":
		_go_to_title_screen()
		

func _input(event):
	if (event is InputEventMouseButton and event.is_pressed()) \
		or event.is_action_released("p1_fire") \
		or event.is_action_released("p2_fire"):
			$AnimationPlayer.play("Fall")


func _on_AnimationPlayer_animation_finished(_anim_name):
	_go_to_title_screen()
	

func _go_to_title_screen():
	get_tree().change_scene_to(TITLE)
