class_name Team
extends Node


const NO_TEAM_NUMBER: int = -1

var team_number: int setget set_team_number
var slots_count: int setget set_slots_count, get_slots_count

var _tree: Tree
var _tree_item: TreeItem
var _slots: Array
var _used_slots_count: int
var _enable_text_updates: bool


func _init(tree: Tree, number: int, slots: int) -> void:
	_tree = tree
	_tree_item = _tree.create_item(_tree.get_root())
	self.team_number = number
	self.slots_count = slots

	# Update team text after initialization
	_enable_text_updates = true
	_update_text()


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_tree_item.free()


func set_team_number(number: int) -> void:
	team_number = number
	_update_text()


func set_slots_count(count: int) -> void:
	if _slots.size() == count:
		return

	if _slots.size() < count:
		for _slot_index in range(_slots.size(), count):
			var slot := Slot.new(_tree.create_item(_tree_item))
			# warning-ignore:return_value_discarded
			slot.connect("id_changed", self, "_update_used_slots")
			_slots.append(slot)
	else:
		Utils.truncate_and_free(_slots, count)
	_update_text()


func get_slots_count() -> int:
	return _slots.size()


func get_slot(slot_index: int) -> Slot:
	 return _slots[slot_index]


func _update_used_slots(previous_slot_id: int, current_slot_id: int) -> void:
	if previous_slot_id == Slot.EMPTY_SLOT and current_slot_id != Slot.EMPTY_SLOT:
		_used_slots_count += 1
	elif previous_slot_id != Slot.EMPTY_SLOT and current_slot_id == Slot.EMPTY_SLOT:
		_used_slots_count -= 1

	_update_text()


func _update_text() -> void:
	if not _enable_text_updates:
		return

	if team_number == NO_TEAM_NUMBER:
		_tree_item.set_text(0, "Players (%d/%d)" % [_used_slots_count, _slots.size()])
	else:
		_tree_item.set_text(0, "Team %d (%d/%d)" % [team_number, _used_slots_count, _slots.size()])
