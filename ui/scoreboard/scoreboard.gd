class_name Scoreboard
extends WindowDialog


signal closed

onready var _tree: ScoreboardTree = $VBox/Tree
onready var _close_button: Button = $VBox/CloseButton


func _input(event: InputEvent) -> void:
	if not event.is_action("ui_scoreboard"):
		return

	if visible and not event.is_pressed():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		hide()
	elif not visible and event.is_pressed():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		show()


func show_final_score() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(false)
	_close_button.show()
	show()


func _close() -> void:
	hide()
	emit_signal("closed")
