class_name ErrorDialog
extends AcceptDialog


func show_error(error_text: String) -> void:
	if CmdArguments.server:
		print(error_text)
		get_tree().quit()
	else:
		dialog_text = error_text
		popup_centered()
