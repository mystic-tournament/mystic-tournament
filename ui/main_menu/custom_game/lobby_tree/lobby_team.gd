class_name LobbyTeam
extends LobbyTreeItem
# Represents team in LobbyTree
# Displays the team number and its slots
# Can be without number to just represent all players


signal filled_changed(is_full)

enum Buttons {
	JOIN
}

const NO_TEAM_NUMBER: int = -1

puppetsync var team_number: int setget set_team_number

var _slots: Array
var _used_slots_count: int


# TODO 4.0: Use TeamTree type for tree (cyclic dependency)
func _init(tree: Tree, number: int, slots).(tree, tree.get_root()) -> void:
	tree.add_child(self, true)
	_add_button(Buttons.JOIN)

	# TODO 4.0: Check if this setter call text update twice
	team_number = number
	add_slots(slots)


func _exit_tree() -> void:
	# Disconnect slots destroy callback to avoid crashes and unnecessary text updates
	for slot in _slots:
		slot.disconnect("destroyed", self, "_on_slot_id_changed")


func set_team_number(number: int) -> void:
	team_number = number
	_update_text()


puppetsync func add_slots(slots) -> void:
	if typeof(slots) == TYPE_INT_ARRAY:
		for id in slots:
			_create_slot(id)
	else:
		for _i in range(slots):
			_create_slot(LobbySlot.EMPTY_SLOT)
	_update_text()


puppetsync func truncate(size: int) -> void:
	Utils.truncate_and_free(_slots, size)


func find_slot(id: int) -> LobbySlot:
	for slot in _slots:
		if slot.id == id:
			return slot
	return null


func size() -> int:
	return _slots.size()


func get_slot(idx: int) -> LobbySlot:
	return _slots[idx]


func get_slot_ids() -> PoolIntArray:
	var array: PoolIntArray = []
	for slot in _slots:
		array.append(slot.id)
	return array


func is_full() -> bool:
	return _slots.size() == _used_slots_count


func _on_slot_id_changed(slot: LobbySlot, previous_slot_id: int) -> void:
	if previous_slot_id == LobbySlot.EMPTY_SLOT and slot.id != LobbySlot.EMPTY_SLOT:
		_used_slots_count += 1
		if is_full():
			emit_signal("filled_changed")
	elif previous_slot_id != LobbySlot.EMPTY_SLOT and slot.id == LobbySlot.EMPTY_SLOT:
		_move_slot_down(slot)
		_used_slots_count -= 1
		if _slots.size() == _used_slots_count + 1:
			emit_signal("filled_changed")

	if slot.id == get_tree().get_network_unique_id():
		_remove_button(Buttons.JOIN)
	elif previous_slot_id == get_tree().get_network_unique_id():
		_add_button(Buttons.JOIN)

	_update_text()


func _create_slot(id: int) -> void:
	var slot := LobbySlot.new(self, id)
	# warning-ignore:return_value_discarded
	slot.connect("id_changed", self, "_on_slot_id_changed")
	# warning-ignore:return_value_discarded
	slot.connect("destroyed", self, "_on_slot_id_changed", [slot, LobbySlot.EMPTY_SLOT])
	_slots.append(slot)
	if id != LobbySlot.EMPTY_SLOT:
		_on_slot_id_changed(slot, LobbySlot.EMPTY_SLOT)


func _move_slot_down(slot: LobbySlot) -> void:
	_slots.remove(_slots.find(slot))
	_slots.append(slot)
	slot.get_tree_item().move_to_bottom()


func _update_text() -> void:
	if team_number == NO_TEAM_NUMBER:
		_tree_item.set_text(0, "Players (%d/%d)" % [_used_slots_count, _slots.size()])
	else:
		_tree_item.set_text(0, "Team %d (%d/%d)" % [team_number, _used_slots_count, _slots.size()])
