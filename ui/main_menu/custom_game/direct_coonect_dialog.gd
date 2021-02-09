class_name DirectConnectDialog
extends ConfirmationDialog


var address: String setget set_address, get_address
var port: int setget set_port, get_port

onready var _address_edit: LineEdit = $Grid/AddressEdit
onready var _port_spin: SpinBox = $Grid/PortSpin


func set_address(value: String) -> void:
	_address_edit.text = value


func get_address() -> String:
	return _address_edit.text


func set_port(value: int) -> void:
	_port_spin.value = value


func get_port() -> int:
	return int(_port_spin.value)
