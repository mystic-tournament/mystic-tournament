extends BaseGamemodeOption


onready var _kills_count: SpinBox = $SpinBox


func apply_settings() -> void:
	GameSession.gamemode.kills_count = _kills_count.value
