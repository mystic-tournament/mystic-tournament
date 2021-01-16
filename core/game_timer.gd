class_name GameTimer
extends Timer
# Expands the basic timer by adding additional signals to it.


signal stopped
signal started(time)


func start(time_sec: float = -1) -> void:
	.start(time_sec)
	emit_signal("started", wait_time)


func stop() -> void:
	.stop()
	emit_signal("stopped")
