extends BaseMap


static func get_supported_modes() -> Array:
	return [preload("res://core/gamemodes/deathmatch.gd"), preload("res://core/gamemodes/kill_giant.gd")]
