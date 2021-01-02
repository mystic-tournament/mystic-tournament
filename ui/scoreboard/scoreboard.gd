class_name Scoreboard
extends WindowDialog


onready var _tree: ScoreboardTree = $Tree


func _input(event: InputEvent) -> void:
	if event.is_pressed() and event.is_action("ui_scoreboard"):
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			hide()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_tree.update_info()
			show()
