class_name ValueBar
extends TextureProgress


onready var _value_label: Label = $ValueLabel
onready var _tween: Tween = $Tween


func reset(new_value: float, new_max_value) -> void:
	value = new_value
	max_value = new_max_value
	_update_value_label()


func set_value_smoothly(new_value: float) -> void:
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "value", value, new_value, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT);

	set_value(new_value)

	# warning-ignore:return_value_discarded
	_tween.start()
	_update_value_label()


func _update_value_label() -> void:
	_value_label.text = "%d/%d" % [value, max_value]
