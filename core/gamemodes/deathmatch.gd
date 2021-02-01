class_name Deathmatch
extends BaseGamemode


var kills_to_win: int


static func name() -> String:
	return "Deathmatch"


static func additional_settings() -> Array:
	return [preload("res://ui/main_menu/custom_game/server_settings/gamemode_options/kills.tscn")]
