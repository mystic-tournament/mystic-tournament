class_name PlayerInfo
extends Node


var controller: BaseController
var team: int
var damage_done: int
var healing_done: int
var deaths: int
var kills: int


func _init(player_team: int) -> void:
	team = player_team
