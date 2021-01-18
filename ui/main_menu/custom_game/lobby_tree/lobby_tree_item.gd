class_name LobbyTreeItem
extends Node
# Wrapper around TreeItem to represent data in LobbyTree
# Automatically creates a child TreeItem for the given object and its Tree.
# It extends Node to allow RPC synchronization


signal destroyed(object)

const WRAPPER_META: String = "wrapper"

var _tree_item: TreeItem

func _init(tree: Tree, root: TreeItem) -> void:
	_tree_item = tree.create_item(root)
	_tree_item.set_meta(WRAPPER_META, self)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_tree_item.free()
		emit_signal("destroyed", self)


func get_tree_item() -> TreeItem:
	return _tree_item


func _add_button(button_type: int) -> void:
	if _tree_item.get_button_count(button_type) == 1:
		return

	# TODO: Replace with icon and add a tooltip
	var temp_image = ImageTexture.new()
	temp_image.create(15, 15, Image.FORMAT_BPTC_RGBA)
	_tree_item.add_button(button_type, temp_image, 0, false)


func _remove_button(button_type: int) -> void:
	if _tree_item.get_button_count(button_type) == 1:
		_tree_item.erase_button(button_type, 0)
