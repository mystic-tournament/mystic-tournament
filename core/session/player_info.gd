class_name PlayerInfo
extends Node


var controller: BaseController
var team: int
var kills: int
var deaths: int
var assists: int
var damage: int
var healing: int


func _init(player_team: int) -> void:
	team = player_team
