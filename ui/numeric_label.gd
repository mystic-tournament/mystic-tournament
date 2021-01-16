class_name NumericLabel
extends Label
# Convinient helper to display integer in label


var number: int setget set_number


func set_number(new_number: int) -> void:
	if number != new_number:
		number = new_number
		text = str(number)


func set_ceil(new_number: float) -> void:
	# TODO 4.0: Remove extra self
	self.number = int(ceil(new_number))
