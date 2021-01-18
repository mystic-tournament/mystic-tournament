class_name LobbySlot
extends LobbyTreeItem
# It's child of a team that represents slot in LobbyTree
# Contains text based on the given ID
# ID can be a peer ID or a special number that represents empty slot / computer


signal id_changed(slot, previous_id)

enum {
	EMPTY_SLOT = 0,
	HOST = 1,
	# All values ​​after 1 corresponds to the player's unique identifier.
}

enum Buttons {
	KICK_PLAYER
}

puppetsync var id: int = -1 setget set_id


# TODO 4.0: Use LobbyTeam type for team (cyclic dependency)
func _init(team: Node, slot_id: int).(team.get_parent(), team.get_tree_item()) -> void:
	team.add_child(self, true)
	self.id = slot_id


puppetsync func set_id(value: int) -> void:
	if id == value:
		return

	var previous_id: int = id
	id = value

	_update_text()
	if get_tree().get_network_unique_id() == HOST:
		if id > HOST:
			_add_button(Buttons.KICK_PLAYER)
		else:
			_remove_button(Buttons.KICK_PLAYER)

	emit_signal("id_changed", self, previous_id)


func _update_text() -> void:
	match id:
		EMPTY_SLOT:
			_tree_item.set_text(0, "Empty slot")
		_:
			_tree_item.set_text(0, str(id)) # TODO: Use nickname here
