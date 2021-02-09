class_name FadeRect
extends ColorRect


signal finished

onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	# warning-ignore:return_value_discarded
	_animation_player.connect("animation_finished", self, "_emit_finished")


func fade_out() -> void:
	_animation_player.play("fade_out")


func fade_in() -> void:
	_animation_player.play("fade_in")


# TODO 4.0: Unbind extra _anim_name and call emit_signal() directly
func _emit_finished(_anim_name: String) -> void:
	emit_signal("finished")
