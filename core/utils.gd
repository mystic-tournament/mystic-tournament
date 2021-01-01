class_name Utils


static func truncate_and_free(array: Array, size: int) -> void:
	assert(array.size() >= size, "Specified size of the array should be bigger or equal than truncation size")
	for _index in range(size, array.size()):
		array.pop_back().free()
