class_name FloatingText
extends Spatial


const AileronSemibold: DynamicFont = preload("res://ui/game_session/floating_text/aileron_semibold.tres")

onready var _viewport: Viewport = $Viewport
onready var _tween: Tween = $Tween


func show_text(damage: int) -> void:
	var label := Label.new()
	label.add_font_override("font", AileronSemibold)
	label.set_text("%+d" % damage)
	label.set_anchors_preset(Control.PRESET_CENTER)
	_viewport.add_child(label)
	_animate(label)


func _animate(label: Label) -> void:
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(label, "modulate:a", 1, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(label, "rect_scale", Vector2.ZERO, Vector2.ONE, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(label, "rect_position:y", _viewport.get_size().y, 0, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.interpolate_callback(label, 1, "queue_free")
	# warning-ignore:return_value_discarded
	_tween.start()
