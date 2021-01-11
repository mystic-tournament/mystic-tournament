class_name Scoreboard
extends WindowDialog


onready var _tree: ScoreboardTree = $Tree


func _input(event: InputEvent) -> void:
	if not event.is_action("ui_scoreboard"):
		return

	if visible and not event.is_pressed():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		hide()
	elif not visible and event.is_pressed():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_tree.update_info()
		show()
