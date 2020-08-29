class_name ConnectionDialog
extends WindowDialog
# Dialog to display incoming connection


signal canceled

onready var _label: Label = $HBox/Label


func _ready() -> void:
	ControlUtils.disable_input_when_hidden(self)


func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().set_input_as_handled()
		_cancel()


func show_connecting(address: String, port: int) -> void:
	_label.text = "Connecting to %s:%d" % [address, port]
	popup_centered()


func _cancel() -> void:
	hide()
	emit_signal("canceled")
