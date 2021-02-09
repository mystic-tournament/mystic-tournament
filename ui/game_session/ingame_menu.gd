class_name IngameMenu
extends Control


signal leave_pressed


func _input(event: InputEvent) -> void:
	if not event.is_action("ui_session_menu") or event.is_pressed():
		return

	if visible:
		_resume()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		show()


func _resume() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()


func _leave() -> void:
	emit_signal("leave_pressed")


func _exit_to_desktop() -> void:
	get_tree().quit()
